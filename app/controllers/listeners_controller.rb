class ListenersController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:create, :update]
  before_action :set_listener, only: [:update, :destroy]

  def create
    @listener = @routine.listeners.build(listener_params)

    @listener.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @listener.update(listener_params)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @listener.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def set_routine
    @routine = Routine.find(params[:routine_id])
  end

  def set_listener
    @listener = Listener.find(params[:id])
  end

  def listener_params
    params.require(:listener).permit(:sensor_id, :gt, :lt)
  end
end
