class SmallStepsController < ApplicationController
  def create
    @program = current_practice.programs.find(params[:small_step][:program_id])
    @week = @program.weeks.find(params[:small_step][:week_id])

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
    @week = @program.weeks.find(params[:small_step][:week_id])

    # Remove the old HABTM relationship
    @old_small_step = @program.small_steps.find(params[:id])
    @program.weeks.find(@week.id).small_steps.delete(@old_small_step.id)

    # Create a new small step and relationship to the week
    @small_step = @week.small_steps.build(small_step_params)

    # Create a new big step if needed
    big_step = params[:small_step][:big_step_id] # If it's a new big step, this will be the new big step name
    big_step_id = big_step.to_i # If it's a big step name, this will be 0 (new big step)

    if big_step_id == 0
      @big_step = @program.big_steps.where(name: big_step).first_or_create!
      params[:small_step][:big_step_id] = @big_step.id
      @big_step.small_steps << @small_step
      @big_step.save!
      @week.small_steps << @small_step
    end

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
