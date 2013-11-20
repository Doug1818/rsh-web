class Api::V1::SessionsController < Api::V1::ApplicationController
  def create
    @program = Program.where(authentication_token: params[:authentication_token]).first

    if @program.present?

      # sign_in @program.user, store: false
      render status: 200, json: {
        success: true,
        data: { user: current_user, program: @program }
      }
    else
      render json: { success: false }
    end
  end
end
