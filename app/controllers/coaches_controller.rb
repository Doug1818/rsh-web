class CoachesController < ApplicationController

  before_filter :authenticate_coach!, except: [:edit, :update]
  authorize_resource

  def index
    @coaches = current_practice.coaches
  end

  def show
    @coach = current_practice.coaches.find(params[:id])

    if params[:search].present?
      @search = Program.search(include: :user) do
        fulltext params[:search]
        with :coach_id, current_coach.id
      end
      @programs = ProgramDecorator.decorate_collection(@search.results)
    elsif params[:filter].present? and @coach.programs.respond_to?(params[:filter])
      @programs = @coach.programs.send(params[:filter]).decorate
    else
      @programs = @coach.programs.includes(:user).decorate
    end
  end

  def new
    @coach = Coach.new
  end

  def create
    @coach = Coach.new(coach_params)
    @coach.role = 'coach'
    @coach.status = Coach::STATUSES[:invited]
    @coach.practice = current_practice

    respond_to do |format|
      if @coach.save
        format.html { redirect_to(coaches_path) }
        format.json { render json: @coach, status: :created, location: @coach }
      else
        format.html { render action: "new" }
        format.json { render json: @coach.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    if params[:invite_token]
      @coach = Coach.where(invite_token: params[:invite_token]).first
    else
      @coach = current_practice.coaches.find(params[:id])
    end
  end

  def update
    if params[:invite_token]
      @coach = Coach.where(invite_token: params[:invite_token]).first
    else
      @coach = current_practice.coaches.find(params[:id])
    end

    respond_to do |format|
      if @coach.update_attributes(coach_params)

        if params[:invite_token]
          @coach.status = Coach::STATUSES[:active]
          @coach.save

          # @coach.confirmation_email
          sign_in :coach, @coach
          format.html { redirect_to coach_path, notice: "Welcome!" }
        else
          format.html { redirect_to coaches_path, notice: "Coach was successfully updated" }
        end
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @coach = current_practice.coaches.find(params[:id])
    @coach.destroy

    respond_to do |format|
      format.html { redirect_to coaches_path, notice: "#{@coach.email} was successfully deleted." }
    end
  end

  def coach_params
    params.require(:coach).permit(:first_name, :last_name, :password, :password_confirmation, :email, :gender, :status)
  end
end
