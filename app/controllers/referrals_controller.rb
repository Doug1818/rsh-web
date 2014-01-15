class ReferralsController < ApplicationController
  before_filter :authenticate_coach!
  authorize_resource
  
	def new
		@referral = Referral.new
	end

	def create
    @referral = current_coach.referrals.build(referral_params)

    respond_to do |format|
      if @referral.save
      	UserMailer.coach_referral_email(@referral).deliver
        format.html { redirect_to new_referral_path, notice: "Referral email successfully sent." }
        format.json { render json: @referral, status: :created, location: @referral }
      else
        format.html { render action: "new" }
        format.json { render json: @referral.errors, status: :unprocessable_entity }
      end
    end
	end

	def referral_params
    params.require(:referral).permit(:email)
  end
end
