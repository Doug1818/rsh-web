class PracticesController < ApplicationController
  before_filter :authenticate_coach!, only: [:show, :billing]
  before_filter :authenticate_admin!, only: [:index]
  authorize_resource

  def index
    @practices = Practice.all
  end

  def show
    @practice = Practice.find(params[:id])
  end

  def new
    if current_admin || session[:referral_code]
      @practice = Practice.new
      @coach = @practice.coaches.build
    end
  end

  def create
    @practice = Practice.new(practice_params)
    respond_to do |format|
      if @practice.save
        coach = @practice.coaches.first
        coach.role = 'owner'
        if session[:referral_code]
          coach.status = Coach::STATUSES[:active]
          coach.save
          sign_in(coach)
          format.html { redirect_to coach_path(coach), notice: "Welcome!" }
        elsif current_admin
          coach.status = Coach::STATUSES[:invited]
          coach.save
          UserMailer.practice_invitation_email(coach).deliver
          format.html { redirect_to practices_path, notice: "Practice was successfully added" }
        end
        format.json { render json: @practice, status: :created, location: @practice }
      else
        format.html { render action: "new" }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if params[:invite_token]
      @coach = Coach.where(invite_token: params[:invite_token]).first
      @practice = Practice.find(@coach.practice_id)
    elsif current_admin
      @practice = Practice.find(params[:id])
      @coach = @practice.coaches.where(role: "owner").first
    end
  end

  def update
    if params[:invite_token]
      @coach = Coach.where(invite_token: params[:invite_token]).first
      @practice = Practice.find(@coach.practice_id)
    elsif current_admin
      @practice = Practice.find(params[:id])
    end

    respond_to do |format|
      if @practice.update_attributes(practice_params)

        if params[:invite_token]
          @coach.status = Coach::STATUSES[:active]
          @coach.save

          # @coach.confirmation_email
          sign_in :coach, @coach
          format.html { redirect_to coach_path(@coach), notice: "Welcome!" }
        else
          format.html { redirect_to practices_path, notice: "Coach was successfully updated" }
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  def billing
    @practice = Practice.find(params[:id])
    @coach = @practice.coaches.where(role: "owner").first
  end

  def add_billing_info
    current_practice.stripe_card_token = params[:practice][:stripe_card_token]
    if current_practice.save_with_payment
      redirect_to root_path, notice: "Billing info added successfully"
    else
      render "billing"
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy

    respond_to do |format|
      format.html { redirect_to practices_path, notice: "#{@practice.name} was successfully deleted." }
    end
  end

  def practice_params
    params.require(:practice).permit(:hipaa_compliant, :terms, :name, :address, :state, :city, :zip, coaches_attributes: [:id, :referred_by_code, :full_name, :first_name, :last_name, :gender, :email, :password, :password_confirmation])
  end
end
