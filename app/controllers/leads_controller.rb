class LeadsController < ApplicationController
	def create
		@lead = Lead.new(lead_params)
		respond_to do |format|
      if @lead.save_with_mailchimp
        format.html { redirect_to root_url, notice: "Thanks for your interest!" }
        format.json { render json: @lead, status: :created, location: @lead }
      else
        format.html { render "home/guest_homepage", layout: "landing_layout" }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
	end

	def lead_params
		params.require(:lead).permit(:name, :email)
	end
end
