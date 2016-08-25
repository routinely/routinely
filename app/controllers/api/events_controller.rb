module Api
  class EventsController < ApplicationController
    def create
      Event.create(event_params)
      head :ok
    end

    private

    def event_params
      params.require(:event).permit(:kind, :routine_type, :routine_id)
    end
  end
end
