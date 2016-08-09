module Api
  class CalendarsController < ApplicationController
    before_action :require_login

    def show
      render json: current_user.group.time_based_routines
    end
  end
end
