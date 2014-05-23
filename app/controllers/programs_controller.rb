class ProgramsController < ApplicationController
  before_filter :authenticate_coach!, except: [:index, :show]
  authorize_resource

  def index
    if current_coach
      @programs = current_practice.programs
    elsif current_admin
      @programs = Program.all
    end
  end

  def show
    if current_coach
      @program = current_coach.programs.find(params[:id]).decorate
    elsif current_admin
      @program = Program.find(params[:id]).decorate
    end

    @weeks = @program.weeks.includes(:small_steps => [:big_step]).includes(:check_ins)
    @week = @program.weeks.build(number: 1) # for first week
    @week.small_steps.build # for first week

    @alerts = @program.alerts.decorate
    @reminders = @program.reminders.decorate
    @accomplishments = @program.accomplishments
    # @supporters = @program.supporters
    # @todos = @program.todos

    @active = if params[:active]
      params[:active]
    else
      'steps'
    end
  end

  def new
    @program = Program.new
    @program.build_user
  end

  def create
    @program = Program.new(program_params)
    @program.coaches << current_coach

    if current_coach.practice.hipaa_compliant?
      @program.user.hipaa_compliant = true
      @program.user.create_on_truevault

      first_name = @program.user.first_name
      email = @program.user.email
      @program.user.clear_pii
    end

    # @program.coach_id = current_coach.id # get rid of this once HABTM switch is complete

    respond_to do |format|
      if @program.save

        if @program.user.hipaa_compliant?
          UserMailer.user_invitation_email(@program, current_coach, email, first_name).deliver
        else
          UserMailer.user_invitation_email(@program, current_coach, @program.user.email, @program.user.first_name).deliver
        end

        format.html { redirect_to program_path(@program), notice: "Your client was successfully added and emailed with instructions to download the Steps mobile app" }
        format.json { render json: @program, status: :created, location: @program }
      else
        format.html { render action: "new" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end


  # Non restful methods to accommodate the final two steps of creating a new program
  def new_big_steps
    @program = current_practice.programs.find(params[:id])
    @program.big_steps.build
  end

  def new_small_steps
    @program = current_practice.programs.find(params[:id])
    @week = @program.weeks.build(number: 1)
    @week.small_steps.build
    # @program.small_steps.build
  end

  def update_big_steps
    @program = current_practice.programs.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(program_params)
        format.html { redirect_to new_small_steps_path }
      else
        format.html { render action: "new_big_steps" }
      end
    end
  end

  def update_small_steps
    @program = current_practice.programs.find(params[:id])

    # get the start date of the program (based on the attributes)
    # set the start/end dates of the week
    program_start_date = Date.parse(params[:program][:start_date])
    week_start_date = program_start_date
    week_end_date = program_start_date.end_of_week(:sunday)

    params[:program][:weeks_attributes]["0"][:start_date] = week_start_date
    params[:program][:weeks_attributes]["0"][:end_date] = week_end_date
    @week = @program.weeks.create(number: 1, start_date: week_start_date, end_date: week_end_date)

    # Create new steps
    small_steps = params[:program][:weeks_attributes]["0"][:small_steps_attributes]
    small_steps.each do |small_step|
      big_step = small_step[1][:big_step_id] # If it's a new big step, this will be the new big step name
      big_step_id = big_step.to_i # If it's a big step name, this will be 0 (new big step)
      if big_step_id == 0
        # @week = @program.weeks.build
        @small_step = @week.small_steps.build(small_step[1].except(:_destroy))
        @big_step = @program.big_steps.where(name: big_step).first_or_create!
        small_step[1][:big_step_id] = @big_step.id
        @big_step.small_steps << @small_step
        @big_step.save!
        @week.small_steps << @small_step
      end
    end
    
    respond_to do |format|
      if @program.update_attributes(program_params.except(:weeks_attributes))
        @program.start_date = @program.weeks.first.start_date # Redundant code b/c somehow start_date is still getting lost sometimes
        @program.save # Redundant code b/c somehow start_date is still getting lost sometimes
        format.html { redirect_to program_path(@program) }
      else
        format.html { redirect_to program_path(@program) }
        # format.html { render action: "new_small_steps" }
      end
    end
  end

  def update
    @program = current_practice.programs.find(params[:id])

    new_coach_name = params[:program][:new_coach]
    if new_coach_name != nil && new_coach_name != ""
      new_coach = current_practice.coaches.where(first_name: new_coach_name.split(" ")[0], last_name: new_coach_name.split(" ")[1]).last
      new_coach.programs << @program

      if @program.user.hipaa_compliant?
        user_pii = @program.user.get_pii
        full_name, first_name = "#{ user_pii['first_name'] } #{ user_pii['last_name'] }", user_pii['first_name']
      else
        full_name, first_name = @program.user.full_name, @program.user.first_name
      end

      UserMailer.coach_shared_client_email(@program, new_coach, current_coach, full_name, first_name).deliver
    end
    
    respond_to do |format|
      if @program.update_attributes(program_params)

        full_name = if @program.user.hipaa_compliant?
          user_pii = @program.user.get_pii
          "#{ user_pii['first_name'] } #{ user_pii['last_name'] }"
        else
          @program.user.full_name
        end

        format.html { redirect_to(program_path(@program, active: 'client-info'), notice: "#{full_name} was successfully updated") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @program = current_practice.programs.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to programs_path, notice: "Successfully deleted." }
    end
  end


  def program_params
    params.require(:program).permit(:purpose, :goal, :start_date, user_attributes: [:hipaa_compliant, :full_name, :email, :first_name, :last_name, :gender, :id], big_steps_attributes: [:name, :id, :_destroy], weeks_attributes: [:number, :start_date, :end_date, small_steps_attributes: [:name, :program_id, :big_step_id, :frequency, :times_per_week, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :_destroy, :id]])
  end
  
end
