class HomeController < ApplicationController
  def index
    respond_to do |format|
      if current_coach
        authorize!(:index, :coaches_home)
        format.html { render "coaches_homepage" }
      else
        format.html { render "guest_homepage" }
      end
    end
  end
end
