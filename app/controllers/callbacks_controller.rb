class CallbacksController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:create, :update]
  before_action :set_callback, only: [:update, :destroy]

  def create
    @callback = @routine.callbacks.build(callback_params.except(:routine_id, :target_global_id))

    unless @callback.target.present?
      @callback.target = GlobalID::Locator.locate(callback_params[:target_global_id])
    end

    @callback.save
    Flows::SyncService.new(@routine).run!

    respond_to do |format|
      format.js
    end
  end

  def update
    @callback.update(callback_params.except(:routine_id, :target_global_id))
    Flows::SyncService.new(@routine).run!

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @routine = @callback.routine
    @callback.destroy
    Flows::SyncService.new(@routine).run!

    respond_to do |format|
      format.js
    end
  end

  private

  def set_routine
    @routine = GlobalID::Locator.locate(callback_params[:routine_id])
  end

  def set_callback
    @callback = ::Callback.find(params[:id])
  end

  def callback_params
    permitted_params = params.require(:callback).permit(:routine_id, :type, :target_global_id, :delay, :once)
    permitted_params.merge(payload: params[:callback][:payload].to_json)
  end
end
