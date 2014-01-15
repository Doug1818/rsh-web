class Api::V1::ExcusesController < Api::V1::ApplicationController
  
  # Get all of the excuses for a program
  def index
    @excuses = @practice.excuses
    @excuses_data = @excuses.as_json(only: [:id, :name])

    render status: 200, json: {
      success: true,
      data: { excuses: @excuses_data }
    }
  end
end
