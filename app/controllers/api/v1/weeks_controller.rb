class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get the current week for the current program
  def index
    date = params[:date]
    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).as_json(include: { small_steps: { only: [:id, :name]}})

    render status: 200, json: {
      success: true,
      data: { week: @week }
    }
  end
end
