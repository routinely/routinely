module Api
  class EventsController < ApplicationController
    def create
      routine = event_params[:type].constantize.find(event_params[:routine_id])
      Event.create(routine: routine, kind: "triggered")

      head :ok
    end

    private

    def event_params
      params.require(:event).permit(:type, :routine_id)
    end
  end
end
