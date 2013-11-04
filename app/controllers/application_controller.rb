class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_ability
    @current_ability ||= CoachAbility.new(current_coach)
  end

  def current_practice
    current_coach.practice if current_coach
  end
  helper_method :current_practice
end
