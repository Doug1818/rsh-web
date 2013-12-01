class CoachesController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def index
    @coaches = current_practice.coaches
  end

  def show
    @coach = current_practice.coaches.find(params[:id])
    @programs = @coach.programs.includes(:user)
  end

  def new
    @coach = Coach.new
  end

  def edit
    @coach = current_practice.coaches.find(params[:id])
  end

  def update
    @coach = current_practice.coaches.find(params[:id])

    respond_to do |format|
      if @coach.update_attributes(coach_params)
        format.html { redirect_to coaches_path, notice: "#{@coach.full_name} was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def coach_params
    params.require(:coach).permit(:first_name, :last_name, :password, :password_confirmation, :email, :gender, :status)
  end
end
