class SupportersController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def new
    @program = current_coach.programs.find(params[:program_id])
    @supporter = @program.supporters.new
  end

  def create
    @supporter = Supporter.new(supporter_params)
    @program = current_coach.programs.find(@supporter.program_id)

    respond_to do |format|
      if @program.present? && @supporter.save
        format.html { redirect_to(program_path(@program)) }
        format.json { render json: @supporter, status: :created, location: @supporter }
      else
        format.html { render action: "new" }
        format.json { render json: @supporter.errors, status: :unprocessable_entity }
      end
    end
  end

  def supporter_params
    params.require(:supporter).permit(:email, :program_id)
  end
end
