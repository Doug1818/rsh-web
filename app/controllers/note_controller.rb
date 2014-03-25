class NoteController < ApplicationController
  def index
    @small_step = SmallStep.find(params[:small_step_id])
    @note = @small_step.note || @small_step.build_note
    @attachments = @small_step.attachments
    @week = Week.find(params[:week_id])
  end


  def update
    @small_step = SmallStep.find(params[:small_step_id])
    @program = @small_step.program
    @note = @small_step.note

    respond_to do |format|
      if @note.update_attributes(note_params)
        format.html { redirect_to(program_path(@program), notice: "Your notes were successfully updated.")  }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @small_step = SmallStep.find(params[:small_step_id])
    @program = @small_step.program
    @note = Note.new(note_params)
    @note.small_step = @small_step

    respond_to do |format|
      if @note.save
        format.html { redirect_to(program_path(@program), notice: "Your notes were successfully added.")  }
        format.json { render json: @note, status: :created, location: @note }
      end
    end
  end

  def note_params
    params.require(:note).permit(:body)
  end
end
