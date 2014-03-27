class UsersController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def index
    @users = current_practice.users
  end

  def edit
    @user = current_practice.users.find(params[:id])
  end


  def update
    @user = current_practice.users.find(params[:id])
    @program = @user.programs.last

    new_coach_name = params[:user][:new_coach]
    if new_coach_name != ""
      new_coach = current_practice.coaches.where(first_name: new_coach_name.split(" ")[0], last_name: new_coach_name.split(" ")[1]).last
      new_coach.programs << @program
      new_coach.save
      UserMailer.coach_shared_client_email(@program, new_coach, current_coach).deliver
    end

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(program_path(@program, active: 'client-info'), notice: "#{@user.full_name} was successfully updated") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :avatar, :gender, :status, :password, :password_confirmation)
  end
end
