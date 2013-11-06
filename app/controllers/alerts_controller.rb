class AlertsController < ApplicationController
  def new
    @program = current_coach.programs.find(params[:program_id])
    @alert = @program.alerts.new
  end

  def create
    @alert = Alert.new(alert_params)
    @program = current_coach.programs.find(@alert.program_id)

    respond_to do |format|
      if @program.present? && @alert.save
        format.html { redirect_to(program_path(@program)) }
        format.json { render json: @alert, status: :created, location: @alert }
      else
        format.html { render action: "new" }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  def alert_params
    params.require(:alert).permit(:action_type, :streak, :sequence, :program_id)
  end
end
