class TimeBasedRoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:edit, :update, :destroy]

  def show
    @routine = TimeBasedRoutine.find(params[:id])
  end

  def new
    @routine = TimeBasedRoutine.new
  end

  def edit
  end

  def create
    @routine = current_user.group.rule_based_routines.build(routine_params)

    if @routine.save
      redirect_to @routine, notice: "Routine was successfully created."
    else
      render :new
    end
  end

  def update
    if @routine.update(routine_params)
      redirect_to @routine, notice: "Routine was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_routine
    @routine = TimeBasedRoutine.find(params[:id])
  end

  def routine_params
    params.require(:time_based_routine).permit(:name, :description, :triggers_at, repeats_at: [])
  end
end
