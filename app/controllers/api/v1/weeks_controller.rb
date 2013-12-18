class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get all the weeks for a program
  def index
    @weeks = @program.weeks.order(:start_date)

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
