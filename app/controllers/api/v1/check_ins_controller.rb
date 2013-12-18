class Api::V1::CheckInsController < Api::V1::ApplicationController
  def new
    week_id = params[:week_id]
    small_step_id = params[:small_step_id]
    date = Date.parse(params[:date])

    status = params[:status]

    @small_step = @program.small_steps.find small_step_id

    if @small_step.present?
      @check_in = @small_step.check_ins.create(created_at: date, week_id: week_id)
      @check_in.activities.create(status: status, created_at: date, small_step_id: small_step_id)
      @check_in.save!

      render status: 200, json: {
        success: true,
        data: {}
      }
    end
  end
end
