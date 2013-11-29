class SmallStepsController < ApplicationController
  def create
    @program = current_practice.programs.find(params[:small_step][:program_id])
    @week = @program.weeks.find(params[:week_id])

    @small_step = @week.small_steps.build(small_step_params)

    respond_to do |format|
      if @week.save
        format.html { redirect_to(program_path(@small_step.program)) }
        format.json { render json: @small_step, status: :created, location: @small_step }
      else
        format.html { render action: "new" }
        format.json { render json: @small_step.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @program = current_practice.programs.find(params[:small_step][:program_id])
    @small_step = @program.small_steps.find(params[:id])

    respond_to do |format|
      if @small_step.update_attributes(small_step_params)
        format.html { redirect_to(program_path(@small_step.program)) }
      end
    end
  end

  def destroy
    @program = current_practice.programs.find(params[:program_id])
    @week = @program.weeks.find(params[:week_id])
    @small_step = @program.small_steps.find(params[:id])

    @program.small_steps.find(@small_step.id).weeks.delete(@week.id)

    respond_to do |format|
      format.html { redirect_to(program_path(@program)) }
    end
  end


  def small_step_params
    params.require(:small_step).permit(:name, :program_id, :big_step_id, :frequency, :times_per_week, :sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :_destroy, :id)
  end
end
