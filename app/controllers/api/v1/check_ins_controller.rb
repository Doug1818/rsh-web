class Api::V1::CheckInsController < Api::V1::ApplicationController
  def create

    small_steps = params[:small_steps]
    status = params[:status]
    week_id = params[:week_id]
    date = Date.parse(params[:date])
    
    if small_steps.count > 0
      @check_in = @program.check_ins.where(created_at: date, week_id: week_id).first_or_create

      small_steps.each do |small_step|
        @check_in.activities.create(status: status, created_at: date, small_step_id: small_step['id'])
        @check_in.save!
      end
    end

    render status: 200, json: {
      success: true,
      data: {}
    }
  end

  def update
      
    small_steps = params[:small_steps]
    status      = params[:status]
    week_id     = params[:week_id]
    date        = Date.parse(params[:date])

    if small_steps.count > 0
      @check_in = @program.check_ins.where(created_at: date, week_id: week_id).first

      unless @check_in.nil?
        @check_in.update_attributes({ created_at: date, week_id: week_id })

        small_steps.each do |small_step|
          @check_in.activities.each do |activity|
            activity.update_attributes({ status: status, created_at: date, small_step_id: small_step['id'] })
          end
          @check_in.save!
        end
      end
    end

    render status: 200, json: {
      success: true,
      data: {}
    }
  end
end
