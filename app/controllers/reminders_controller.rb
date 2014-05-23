class RemindersController < ApplicationController
  before_filter :authenticate_coach!, :unless => :non_coach_resource_signed_in
  before_filter :authenticate_user!, :unless => :non_user_resource_signed_in
  authorize_resource

  def new
    @program = current_coach.programs.find(params[:program_id])
    @reminder = @program.reminders.new
  end

  def create
    @reminder = Reminder.new(reminder_params)
    if current_coach
      @program = current_coach.programs.find(@reminder.program_id)
    elsif current_user
      @program = current_user.programs.find(@reminder.program_id)
    end

    respond_to do |format|
      if @program.present? && @reminder.save
        format.html { redirect_to(program_path(@program, active: 'notifications'), notice: "Reminder successfully created") }
        format.json { render json: @reminder, status: :created, location: @reminder }
      else
        format.html { redirect_to(program_path(@program, active: 'notifications'), notice: "Your reminder is missing required fields. Please try again.") }
        format.json { render json: @reminder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reminder = Reminder.find(params[:id])
    @program = Program.find(@reminder.program_id)
    @reminder.destroy

    respond_to do |format|
      format.html { redirect_to(program_path(@program, active: 'notifications'), notice: "Your reminder has been successfully deleted") }
    end
  end

  def reminder_params
    params.require(:reminder).permit(:body, :frequency, :send_at, :send_on, :program_id, :monthly_recurrence, :weekly_recurrence, :daily_recurrence, :day_of_week, :start_date)
  end
end
