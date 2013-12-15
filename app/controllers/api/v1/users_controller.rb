class Api::V1::UsersController < Api::V1::ApplicationController
  def index

    @user = @program.user

    if @user.present?
      render status: 200, json: {
        success: true,
        data: { user: @user }
      }
    else
      render json: { success: false }
    end
  end
end
