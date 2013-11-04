class PracticesController < ApplicationController
  def new
    @practice = Practice.new
    @practice.coaches.build
  end

  def create
    @practice = Practice.new(practice_params)

    respond_to do |format|
      if @practice.save
        coach = @practice.coaches.first
        coach.role = "owner"
        coach.save

        sign_in(coach)

        format.html { redirect_to(root_url) }
        format.json { render json: @practice, status: :created, location: @practice }
      else
        format.html { render action: "new" }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  def practice_params
    params.require(:practice).permit(:name, :address, :state, :city, :zip, coaches_attributes: [:email, :password, :password_confirmation])
  end
end
