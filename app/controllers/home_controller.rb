class HomeController < ApplicationController
  layout "landing_layout", only: [:index]
  def index
    if current_coach

      redirect_to coach_path(current_coach)
      # authorize!(:index, :coaches_home)
      # @users = current_coach.users
      # format.html { render "coaches_homepage" }
    elsif current_user
      redirect_to program_path(current_user.programs.last)
    elsif current_admin
      redirect_to rshadmin_path
    else
      @lead = Lead.new
      respond_to do |format|
        format.html { render "guest_homepage" }
      end
    end
  end

  def support
  end
end
