module Api
  class RoutinesController < Api::ApplicationController
    def index
      render json: Routine.scheduled.order(starts_at: :asc)
    end
  end
end
