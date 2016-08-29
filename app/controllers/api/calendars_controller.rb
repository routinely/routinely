module Api
  class CalendarsController < ApplicationController
    before_action :require_login

    def show
      render json: (
        current_user.group.time_based_routines +
        current_user.group.rule_based_routines +
        current_user.group.periodic_routines +
        current_user.group.dependent_routine_events.on_start.during_current_week.includes(:routine)),
        root: "events"
    end
  end
end
