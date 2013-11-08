class ProgramsController < ApplicationController
  def show
    @program = current_coach.programs.find(params[:id])
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

  def program_params
    params.require(:program).permit(:purpose, user_attributes: [:full_name, :email])
  end
end
