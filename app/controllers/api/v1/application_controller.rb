class Api::V1::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  respond_to :json

  before_filter :authenticate_program

  def authenticate_program
    if params[:authentication_token].present?
      @program = Program.where(authentication_token: params[:authentication_token]).last
      auth_failure unless @program.present?
    else
      auth_failure
    end
  end

  private

  def auth_failure
    render status: 403, json: { success: false, message: "You must be logged in to continue!" }
  end

end
