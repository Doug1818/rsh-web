class Api::V1::CheckInsController < Api::V1::ApplicationController
  def create
    week_id = params[:week_id]
    small_step_id = params[:small_step_id]
    date = Date.parse(params[:date])

    status = params[:status]

    @small_step = @program.small_steps.find small_step_id

    if @small_step.present?
      @check_in = CheckIn.where(created_at: date, small_step_id: small_step_id).first_or_create(week_id: week_id)
      @check_in.activities.create(status: status, created_at: date, small_step_id: small_step_id)
      @check_in.save!

      render status: 200, json: {
        success: true,
        data: {}
      }
    end
  end
end