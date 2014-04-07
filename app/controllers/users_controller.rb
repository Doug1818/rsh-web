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
    # NOT BEING USED
    #@user = current_practice.users.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(user_params)
        format.html { redirect_to(user_path(@user, active: 'client-info'), notice: "#{@user.full_name} was successfully updated") }
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
