class Api::V1::CheckInsController < Api::V1::ApplicationController
  def create
    status = params[:status]
    week_id = params[:week_id]
    date = Date.parse(params[:date])

    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).first
    @small_steps = @week.small_steps.collect { |ss| ss if ss.required_on_date(date) }.compact

    if @small_steps.count > 0
      @check_in = @program.check_ins.where(created_at: date, week_id: week_id).first_or_create

      @small_steps.each do |small_step|
        @check_in.activities.create(status: status, created_at: date, small_step_id: small_step.id)
        @check_in.save!
      end
    end

    render status: 200, json: {
      success: true,
      data: {}
    }
  end
end