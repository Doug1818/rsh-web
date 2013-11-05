class HomeController < ApplicationController
  def index
    if current_coach

      redirect_to coach_path(current_coach)
      # authorize!(:index, :coaches_home)
      # @users = current_coach.users
      # format.html { render "coaches_homepage" }
    else
      respond_to do |format|
        format.html { render "guest_homepage" }
      end
    end
  end
end
