class Api::V1::SessionsController < Api::V1::ApplicationController
  def create
    if @program.present?
      render status: 200, json: {
        success: true,
        data: { user: @program.user, program: @program }
      }
    end
  end
end
