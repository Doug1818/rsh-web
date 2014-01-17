class Api::V1::ProgramsController < Api::V1::ApplicationController
  
  # Get data for the current program
  def index

    date = Date.parse(params[:date])

    @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).first

    unless @week.nil?
      @program_data = @week.as_json(only: :id)

      check_in_status = @week.check_ins.find_by(created_at: date).status rescue nil

      has_check_in = check_in_status != nil

      @small_steps = @week.small_steps

      @small_steps_data = @small_steps.as_json(only: [:id, :name, :frequency])

      requires_one_or_more_check_ins = false

      @small_steps_data.each do |small_step|
        begin
          @small_step = @program.small_steps.find(small_step['id'])
          small_step['specific_days'] = @small_step.humanize_days
          
          if @small_step.needs_check_in_on_date(date, true)
            small_step['needs_check_in'] = true
            requires_one_or_more_check_ins = true
          else
            small_step['needs_check_in'] = false
          end
          small_step['can_check_in'] = @small_step.can_check_in_on_date(date)
          small_step['has_check_in'] = @small_step.has_check_in_on_date(date)
        rescue ActiveRecord::RecordNotFound
          small_step['needs_check_in'] = false
          small_step['can_check_in'] = false
          small_step['has_check_in'] = false
        end
      end

      @program_data.reverse_merge!({small_steps: @small_steps_data, check_in_status: check_in_status, has_check_in: has_check_in, requires_one_or_more_check_ins: requires_one_or_more_check_ins})
      
    else
      @program_data = { program_start_date: @program.start_date } 
    end

    render status: 200, json: {
      success: true,
      data: { program: @program_data }
    }
  end
end
