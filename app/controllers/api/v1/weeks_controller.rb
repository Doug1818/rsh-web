class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get IDs of all weeks in the program
  def index
    @weeks = @program.weeks.pluck(:id)

    render status: 200, json: {
      success: true,
      data: { weeks: @weeks }
    }
  end

  # Grab a specific week
  def show
    @week = @program.weeks.find_by(id: params[:id]).as_json(include: :small_steps)

    render status: 200, json: {
      success: true,
      data: {week: @week }
    }
  end
end
