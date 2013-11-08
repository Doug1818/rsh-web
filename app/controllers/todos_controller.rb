class TodosController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource

  def new
    @program = current_coach.programs.find(params[:program_id])
    @todo = @program.todos.new
  end

  def create
    @todo = Todo.new(todo_params)
    @program = current_coach.programs.find(@todo.program_id)

    respond_to do |format|
      if @program.present? && @todo.save
        format.html { redirect_to(program_path(@program)) }
        format.json { render json: @todo, status: :created, location: @todo }
      else
        format.html { render action: "new" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  def todo_params
    params.require(:todo).permit(:body, :program_id)
  end
end
