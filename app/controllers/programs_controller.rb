class ProgramsController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def index
    @programs = current_practice.programs
  end

  def show
    @program = current_coach.programs.find(params[:id])

    @small_steps = @program.small_steps.order(week_number: :asc)
    @small_step_weeks = @small_steps.group_by { |t| t.week_number }

    @alerts = @program.alerts
    @reminders = @program.reminders
    @supporters = @program.supporters
    @todos = @program.todos
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
    @program.small_steps.build
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
    respond_to do |format|
      if @program.update_attributes(program_params)
        format.html { redirect_to program_path(@program) }
      else
        format.html { render action: "new_small_steps" }
      end
    end
  end

  def program_params
    params.require(:program).permit(:purpose, user_attributes: [:full_name, :email], big_steps_attributes: [:name, :_destroy], small_steps_attributes: [:name, :big_step_id, :week_number, :frequency, :times_per_week, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :_destroy, :id])
  end
end
