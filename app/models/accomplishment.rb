class Accomplishment < ActiveRecord::Base
	belongs_to :program

	def added_by
		added_by = if user_id?
			User.find(user_id).first_name
		elsif coach_id?
			Coach.find(coach_id).first_name
		end
	end
end
