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
        format.html { redirect_to(program_path(@program, active: 'advanced-settings'), notice: "Reminder successfully created") }
        format.json { render json: @reminder, status: :created, location: @reminder }
      else
        format.html { redirect_to(program_path(@program, active: 'advanced-settings'), notice: "Your reminder is missing required fields. Please try again.") }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reminder = Reminder.find(params[:id])
    @program = Program.find(@reminder.program_id)
    @reminder.destroy

    respond_to do |format|
      format.html { redirect_to(program_path(@program, active: 'advanced-settings'), notice: "Your reminder has been successfully deleted") }
    end
  end

  def reminder_params
    params.require(:reminder).permit(:body, :frequency, :send_at, :send_on, :program_id, :monthly_recurrence, :weekly_recurrence, :daily_recurrence, :day_of_week, :start_date)
  end
end
