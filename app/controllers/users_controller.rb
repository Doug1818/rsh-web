class UsersController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def index
    @users = current_practice.users
  end

  def edit
    @user = current_practice.users.find(params[:id])
  end
end
