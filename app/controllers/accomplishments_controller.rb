class AccomplishmentsController < ApplicationController
  before_filter :authenticate_coach!, :unless => :non_coach_resource_signed_in
  before_filter :authenticate_user!, :unless => :non_user_resource_signed_in
  authorize_resource

  def create
    @accomplishment = Accomplishment.new(accomplishment_params)
    if current_coach
      @program = current_coach.programs.find(@accomplishment.program_id)
    elsif current_user
      @program = current_user.programs.find(@accomplishment.program_id)
    end

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
    params.require(:accomplishment).permit(:name, :date, :program_id, :coach_id, :user_id)
  end
end
