class Api::V1::ProgramsController < Api::V1::ApplicationController
  
  # Get data for the current program
  def index

    date = Date.parse(params[:date])

    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).first
    @program_data = @week.as_json(only: :id)

    check_in = @week.find_check_in_for_day(date)
    check_in_status = check_in.is_a?(CheckIn) ? check_in.status : 0

    @small_steps = @week.small_steps

    @small_step_data = @small_steps.as_json(only: [:name, :requires_check_in], date: date)

    @program_data.reverse_merge!({check_in_status: check_in_status, small_steps: @small_step_data})

    render status: 200, json: {
      success: true,
      data: { program: @program_data }
    }
  end
end
