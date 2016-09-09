class RoutinesController < ApplicationController
  before_action :require_login

  def index
    @periodic_routines = current_user.group.periodic_routines.order(starts_at: :asc).includes(:rf_sensor, :sensors, :actors, :dependent_routines)
    @dependent_routines = current_user.group.dependent_routines.includes(:leading_routine, :rf_sensor, :sensors, :actors)
    @time_based_routines = current_user.group.time_based_routines.order(triggers_at: :asc).includes(:actors)
    @rule_based_routines = current_user.group.rule_based_routines.includes(:rf_sensor, :sensors, :actors)
  end
end
