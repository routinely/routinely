class CallbacksController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:create, :update]
  before_action :set_callback, only: [:update, :destroy]

  def create
    @callback = @routine.callbacks.build(callback_params.except(:target_global_id))

    unless @callback.target.present?
      @callback.target = GlobalID::Locator.locate callback_params[:target_global_id]
    end

    @callback.save

    respond_to do |format|
      format.js
    end
  end

  def update
    @callback.update(callback_params.except(:target_global_id))

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @callback.destroy

    respond_to do |format|
      format.js
    end
  end

  private

  def set_routine
    @routine = Routine.find(params[:routine_id])
  end

  def set_callback
    @callback = ::Callback.find(params[:id])
  end

  def callback_params
    params.require(:callback).permit(:type, :target_global_id, :delay, :once, :payload)
  end
end
