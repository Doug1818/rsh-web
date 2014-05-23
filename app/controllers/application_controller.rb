class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_referral_code

  def store_referral_code
    if params[:referral_code]
      session[:referral_code] = params[:referral_code]
    end
  end

  def current_ability
    @current_ability ||= CoachAbility.new(current_coach)
  end

  def current_practice
    current_coach.practice if current_coach
  end
  helper_method :current_practice

  def non_coach_resource_signed_in
    admin_signed_in? || user_signed_in?
  end

  def non_admin_resource_signed_in
    coach_signed_in? || user_signed_in?
  end

  def non_user_resource_signed_in
    admin_signed_in? || coach_signed_in?
  end

  # Exception handling (custom error messages)
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end

  private
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
      format.all { render nothing: true, status: status }
    end
  end
end
