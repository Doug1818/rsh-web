class ProgramsController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def index
    @programs = current_practice.programs
  end

  def show
    @program = current_coach.programs.find(params[:id]).decorate
    @weeks = @program.weeks.includes(:small_steps => [:big_step]).includes(:check_ins)

    @alerts = @program.alerts
    @reminders = @program.reminders.decorate
    @supporters = @program.supporters
    @todos = @program.todos

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
    @program.coach_id = current_coach.id

    respond_to do |format|
      if @program.save
        format.html
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
    week_start_date = program_start_date.beginning_of_week(:sunday)
    week_end_date = program_start_date.end_of_week(:sunday)

    params[:program][:weeks_attributes]["0"][:start_date] = week_start_date
    params[:program][:weeks_attributes]["0"][:end_date] = week_end_date

    respond_to do |format|
      if @program.update_attributes(program_params)
        format.html { redirect_to program_path(@program) }
      else
        format.html { render action: "new_small_steps" }
      end
    end
  end

  def program_params
    params.require(:program).permit(:purpose, :goal, :start_date, user_attributes: [:full_name, :email], big_steps_attributes: [:name, :_destroy], weeks_attributes: [:number, :start_date, :end_date, small_steps_attributes: [:name, :program_id, :big_step_id, :frequency, :times_per_week, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :_destroy, :id]])
  end
end
