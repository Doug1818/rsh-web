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

  # TODO add strong params, make this more rails-like
  def update
    @user = @program.user
    @user.image_data = params[:avatar]
    @user.phone = params[:phone]
    @user.timezone = params[:timezone]
    @user.save

    render status: 200, json: {
      success: true,
      data: { user: @user }
    }

  end

end
