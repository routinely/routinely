class ListenersController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:create, :update]
  before_action :set_listener, only: [:update, :destroy]

  def create
    sensor = Sensor.find(listener_params[:sensor_id])

    @listener = if sensor.binary?
      @routine.build_rf_listener(listener_params.except(:routine_id))
    else
      @routine.listeners.build(listener_params.except(:routine_id))
    end

    @listener.save
    Flows::SyncService.new(@routine).run!

    respond_to do |format|
      format.js
    end
  end

  def update
    @listener.update(listener_params.except(:routine_id))
    Flows::SyncService.new(@routine).run!

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @routine = @listener.routine
    @listener.destroy
    Flows::SyncService.new(@routine).run!

    respond_to do |format|
      format.js
    end
  end

  private

  def set_routine
    @routine = GlobalID::Locator.locate(listener_params[:routine_id])
    authorize @routine, :update?
  end

  def set_listener
    @listener = Listener.find(params[:id])
    authorize @listener.routine, :update?
  end

  def listener_params
    params.require(:listener).permit(:routine_id, :sensor_id, :gt, :lt)
  end
end
