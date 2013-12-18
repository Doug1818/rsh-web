# class Api::V1::SmallStepsController < Api::V1::ApplicationController
#   def index

#     date = params[:date]
#     @week = @program.weeks.where("DATE(?) BETWEEN start_date AND end_date", date).as_json(include: :small_steps)

#     render status: 200, json: {
#       success: true,
#       data: { week: @week }
#     }
#   end
# end
