class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get all of the weeks for a program
  def index
    @program = @program.decorate
    @weeks = @program.weeks
    @weeks_data = Array.new

    @weeks.each do |week| 

      start_date = week.start_date
      end_date = week.end_date

      week_data = week.as_json(only: [:start_date, :end_date, :number])
      week_data[:days] = Array.new

      (start_date..end_date).each do |date|
        @small_steps = week.small_steps.collect { |small_step| small_step if small_step.required_on_date(date) }.compact

        requires_check_in = @small_steps.count == 0 ? false : true

        check_in = week.find_check_in_for_day(date)
        check_in_status = check_in.is_a?(CheckIn) ? check_in.status : 0

        week_data[:days] << { full_date: date, date: date.strftime('%a %e'), day_number: @program.day_number(date), requires_check_in: requires_check_in, check_in_status: check_in_status, is_future: date.to_time.beginning_of_day.future? }
      end
      @weeks_data << week_data
    end

    render status: 200, json: {
      success: true,
      data: { weeks: @weeks_data }
    }
  end

  # Get the current week for the current program
  def by_date
    date = params[:date]
    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).first
    @week_data = @week.as_json(only: :id)
    @small_steps = @week.small_steps.collect { |ss| ss if ss.required_on_date(date) }.compact

    @small_steps_data = @small_steps.as_json(only: [:id, :name], date: date)
    
    @week_data[:small_steps] = @small_steps_data

    render status: 200, json: {
      success: true,
      data: { week: @week_data }
    }
  end

end
