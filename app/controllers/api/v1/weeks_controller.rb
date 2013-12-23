class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get all of the weeks for a program
  def index
    today = Date.today
    yesterday = Date.yesterday

    @program = @program.decorate
    @weeks = @program.weeks.includes(:check_ins).as_json(except: [:program_id, :created_at, :updated_at])

    @weeks.each do |week| 
      start_date = week['start_date']
      end_date = week['end_date']

      week[:days] = Array.new

      @week = @program.weeks.find week['id']

      (start_date..end_date).each do |date|
        check_in = @week.find_check_in_for_day(date)
        check_in_status = check_in.is_a?(CheckIn) ? check_in.status : 0
        is_future = date.beginning_of_day.in_time_zone('EST') > today.beginning_of_day.in_time_zone('EST') # TODO: Use user's timezone
        today_or_yesterday = (date.beginning_of_day == today.beginning_of_day) || (date.beginning_of_day == yesterday.beginning_of_day)
        week[:days] << {full_date: date, date: date.strftime('%a %e'), day_number: @program.day_number(date), check_in_status: check_in_status, is_future: is_future, today_or_yesterday: today_or_yesterday }
      end
    end

    render status: 200, json: {
      success: true,
      data: { weeks: @weeks }
    }
  end

  # Get the current week for the current program
  def by_date
    date = params[:date]
    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).as_json(include: { small_steps: { only: [:id, :name]}})

    render status: 200, json: {
      success: true,
      data: { week: @week }
    }
  end
end
