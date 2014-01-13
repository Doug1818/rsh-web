class Api::V1::UsersController < Api::V1::ApplicationController
  def index

    @user = @program.user

    user_data = Array.new

    if @user.present?
      user_data << @user
      render status: 200, json: {
        success: true,
        data: { user: user_data }
      }
    else
      render json: { success: false }
    end
  end

  def update
    @user = @program.user

    if @user.update_attributes!(user_params)
      render status: 200, json: {
        success: true,
        data: { user: @user }
      }
    else
      render status: 200, json: {
        success: false,
        data: {}
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:image_data, :phone, :timezone)
  end

end
