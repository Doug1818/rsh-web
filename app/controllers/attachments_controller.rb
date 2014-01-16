class AttachmentsController < ApplicationController
  def create
    @small_step = SmallStep.find(params[:small_step_id])
    @program = @small_step.program
    @attachment = Attachment.new(attachment_params)
    @attachment.small_step = @small_step

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to(program_path(@program), notice: "Your attachments were successfully added.")  }
        format.json { render json: @attachment, status: :created, location: @attachment }
      end
    end
  end

  def attachment_params
    params.require(:attachment).permit(:filename)
  end
end
