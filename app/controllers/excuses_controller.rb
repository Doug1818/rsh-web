class ExcusesController < ApplicationController
  def index
    @excuses = current_practice.excuses
  end

  def create
    @excuse = Excuse.new(excuse_params)
    @excuse.practice = current_practice

    respond_to do |format|
      if @excuse.save
        format.html { redirect_to(excuses_path) }
        format.json { render json: @excuse, status: :created, location: @excuse }
      else
        format.html { render action: "new" }
        format.json { render json: @excuse.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @excuse = current_practice.excuses.find(params[:id])
    @excuse.destroy

    respond_to do |format|
      format.html { redirect_to excuses_path, notice: "#{@excuse.name} was successfully deleted." }
    end
  end

  def excuse_params
    params.require(:excuse).permit(:name)
  end

end
