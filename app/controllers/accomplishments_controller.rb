class AccomplishmentsController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def create
    @accomplishment = Accomplishment.new(accomplishment_params)
    @program = current_coach.programs.find(@accomplishment.program_id)

    respond_to do |format|
      if @program.present? && @accomplishment.save
        format.html { redirect_to(program_path(@program, active: 'accomplishments'), notice: "Your accomplishment has been successfully added.") }
        format.json { render json: @accomplishment, status: :created, location: @accomplishment }
      else
        format.html { render action: "new" }
        format.json { render json: @accomplishment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @accomplishment = Accomplishment.find(params[:id])
    @program = Program.find(@accomplishment.program_id)
    @accomplishment.destroy

    respond_to do |format|
      format.html { redirect_to(program_path(@program, active: 'accomplishments'), notice: "Your accomplishment has been successfully deleted.") }
    end
  end

  def accomplishment_params
    params.require(:accomplishment).permit(:name, :date, :program_id)
  end
end
