class RemindersController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def new
    @program = current_coach.programs.find(params[:program_id])
    @reminder = @program.reminders.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    @program = current_coach.programs.find(@reminder.program_id)

    respond_to do |format|
      if @program.present? && @reminder.save
        format.html { redirect_to(program_path(@program)) }
        format.json { render json: @reminder, status: :created, location: @reminder }
      else
        format.html { render action: "new" }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  def reminder_params
    params.require(:reminder).permit(:body, :frequency, :send_at, :program_id)
  end
end
