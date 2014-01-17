class Api::V1::WeeksController < Api::V1::ApplicationController
  
  # Get all of the weeks for a program
  def index
    @program = @program.decorate
    @weeks = @program.weeks
    @weeks_data = Array.new

    @weeks.each do |week| 

      @small_steps = week.small_steps

      start_date = week.start_date
      end_date = week.end_date

      week_data = week.as_json(only: [:start_date, :end_date, :number])
      week_data[:days] = Array.new

      (start_date..end_date).each do |date|
        needs_check_in = @small_steps.collect { |small_step| small_step.needs_check_in_on_date(date) }.compact.count(true) > 0
        check_in_status = week.check_ins.find_by(created_at: date).status rescue nil
        week_data[:days] << { full_date: date, date: date.strftime('%a %e'), day_number: @program.day_number(date), needs_check_in: needs_check_in, check_in_status: check_in_status, is_future: date.to_time.beginning_of_day.future? }
      end
      @weeks_data << week_data
    end

    render status: 200, json: {
      success: true,
      data: { weeks: @weeks_data }
    }
  end

  # Get the small steps for a given day
  def small_steps_for_day
    date = params[:date]
    date = Date.parse(date) unless date.is_a? Date
    is_update = params[:is_update] || false

    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).first

    @week_data = @week.as_json(only: :id)

    if is_update
      @small_steps = @week.small_steps.collect { |ss| ss if ss.can_check_in_on_date(date) }.compact
      check_in = @week.check_ins.find_by(created_at: date)

      @week_data[:check_in_id] = check_in.id unless check_in.nil?
      @week_data[:check_in_comments] = check_in.comments unless check_in.nil?
    else
      @small_steps = @week.small_steps.collect { |ss| ss if ss.needs_check_in_on_date(date) }.compact
    end
    
    @small_steps_data = @small_steps.as_json(only: [:id, :name, :frequency_name, :times_per_week, :specific_days, :note, :attachments])
    
    @week_data[:small_steps] = @small_steps_data

    render status: 200, json: {
      success: true,
      data: { week: @week_data }
    }
  end

end
