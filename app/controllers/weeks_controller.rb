class WeeksController < ApplicationController
  def create
    @program = current_practice.programs.find(params[:program_id])
    @last_week = @program.weeks.last
    @week = @last_week.dup :include => :small_steps
    # @week = @last_week.clone
    @week.number = @last_week.number + 1

    # TODO set the start & end dates
    program_start_plus_weeks = @program.start_date + (@week.number - 1).weeks
    @week.start_date = program_start_plus_weeks.beginning_of_week(:sunday)
    @week.end_date = program_start_plus_weeks.end_of_week(:sunday)

    respond_to do |format|
      if @week.save
        format.html { redirect_to(program_path(@program)) }
        format.json { render json: @week, status: :created, location: @week }
      else
        format.html { render action: "new" }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end
end
