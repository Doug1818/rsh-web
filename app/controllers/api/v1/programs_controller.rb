class Api::V1::ProgramsController < Api::V1::ApplicationController
  
  # Get data for the current program
  def index

    date = Date.parse(params[:date])

    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).first

    unless @week.nil?
      @program_data = @week.as_json(only: :id)

      check_in = @week.find_check_in_for_day(date)
      check_in_status = check_in.is_a?(CheckIn) ? check_in.status : 0

      @small_steps = @week.small_steps
      @small_step_data = @small_steps.as_json(only: [:name, :frequency, :requires_check_in], date: date)

      requires_one_or_more_check_ins = false

      @small_step_data.each do |small_step| 
        if small_step['requires_check_in']
          requires_one_or_more_check_ins = true 
          break
        end
      end

      @program_data.reverse_merge!({small_steps: @small_step_data, check_in_status: check_in_status, requires_one_or_more_check_ins: requires_one_or_more_check_ins})
      
    else
      @program_data = {} 
    end

    render status: 200, json: {
      success: true,
      data: { program: @program_data }
    }
  end
end
