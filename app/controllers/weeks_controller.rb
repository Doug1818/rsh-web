class WeeksController < ApplicationController
  def create
    @program = current_practice.programs.find(params[:program_id])
    @last_week = @program.weeks.last
    @week = @last_week.dup :include => :small_steps
    # @week = @last_week.clone
    @week.number = @last_week.number + 1

    # TODO set the start & end dates

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
