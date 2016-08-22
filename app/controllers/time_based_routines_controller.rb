class TimeBasedRoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:edit, :update, :destroy]

  def show
    @routine = TimeBasedRoutine.find(params[:id])
  end

  def edit
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end
end
