class AlertsController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def new
    @program = current_coach.programs.find(params[:program_id])
    @alert = @program.alerts.new
  end

  def create
    @alert = Alert.new(alert_params)
    @program = current_coach.programs.find(@alert.program_id)

    respond_to do |format|
      if @program.present? && @alert.save
        format.html { redirect_to(program_path(@program, active: 'advanced-settings')) }
        format.json { render json: @alert, status: :created, location: @alert }
      else
        format.html { render action: "new" }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @alert = Alert.find(params[:id])
    @program = Program.find(@alert.program_id)
    @alert.destroy

    respond_to do |format|
      format.html { redirect_to(program_path(@program, active: 'advanced-settings'), notice: "Your alert has been successfully deleted.") }
    end
  end

  def alert_params
    params.require(:alert).permit(:action_type, :streak, :sequence, :program_id)
  end
end
