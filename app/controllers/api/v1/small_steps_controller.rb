class Api::V1::SmallStepsController < Api::V1::ApplicationController
  def index
    @small_steps = @program.small_steps

    render status: 200, json: {
      success: true,
      data: { small_steps: @small_steps }
    }
  end
end
