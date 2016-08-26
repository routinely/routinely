class DependentRoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:edit, :update, :destroy]

  def show
    @routine = DependentRoutine.find(params[:id])
  end

  def new
    @routine = DependentRoutine.new
    @routine.build_inverse_callback
  end

  def edit
  end

  def create
    @routine = current_user.group.dependent_routines.build(routine_params)

    @routine.inverse_callback.routine_type = PeriodicRoutine.name

    if @routine.save
      redirect_to @routine, notice: "Routine was successfully created."
    else
      render :new
    end
  end

  def update
    if @routine.update(routine_params)
      Flows::SyncService.new(@routine).run!
      redirect_to @routine, notice: "Routine was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @routine.destroy
    Flows::SyncService.new(@routine).run!
    redirect_to routines_url, notice: "Routine was successfully destroyed."
  end

  private

  def set_routine
    @routine = DependentRoutine.find(params[:id])
  end

  def routine_params
    params.require(:dependent_routine).permit(:name, :description, :duration, inverse_callback_attributes: [:id, :routine_id, :type, :delay])
  end
end