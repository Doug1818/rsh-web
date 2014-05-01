class Api::V1::SessionsController < Api::V1::ApplicationController
  def create
    if @program.present?
      @program.user.update_attributes({parse_id: params[:parse_id]}) if params[:parse_id]
      
      render status: 200, json: {
        success: true,
        data: { user: @program.user, program: @program }
      }
    end
  end
end
