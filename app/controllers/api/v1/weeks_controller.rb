class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get all of the weeks for a program
  def index
    @program = @program.decorate
    @weeks = @program.weeks.includes(:check_ins).as_json(except: [:program_id, :created_at, :updated_at], include: { small_steps: { only: :id }})

    @weeks.each do |week| 
      start_date = week['start_date']
      end_date = week['end_date']

      week[:days] = Array.new

      @week = @program.weeks.find week['id']

      (start_date..end_date).each do |date|
        check_in = @week.find_check_in_for_day(date)
        check_in_status = check_in.is_a?(CheckIn) ? check_in.status : 0

        @small_steps = week['small_steps']

        needs_check_in = false
        @small_steps.each do |small_step|
          @small_step = @program.small_steps.find(small_step['id'])
          small_step_data = @small_step.as_json(only: :requires_check_in, date: date)
          needs_check_in = true if small_step_data[:requires_check_in]
        end

        week[:days] << {full_date: date, date: date.strftime('%a %e'), day_number: @program.day_number(date), needs_check_in: needs_check_in, check_in_status: check_in_status, is_future: date.to_time.beginning_of_day.future?, today_or_yesterday: today_or_yesterday?(date.to_time.beginning_of_day) }
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

  private

  def today_or_yesterday?(date)
    yesterday = Date.yesterday.beginning_of_day.in_time_zone('America/New_York').beginning_of_day
    today = Date.today.in_time_zone('America/New_York').end_of_day
    (yesterday..today).cover?(date)
  end
end
