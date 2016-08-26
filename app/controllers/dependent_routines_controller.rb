class DependentRoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:edit, :update, :destroy]

  def show
    @routine = DependentRoutine.find(params[:id])
    @routine.build_rf_listener unless @routine.rf_listener.present?
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
      Flows::SyncService.new(@routine.leading_routine).run!
      redirect_to @routine, notice: "Routine was successfully created."
    else
      render :new
    end
  end

  def update
    if @routine.update(routine_params)
      Flows::SyncService.new(@routine).run!

      if changed = @routine.inverse_callback.previous_changes[:routine_id]
        Flows::SyncService.new(PeriodicRoutine.find(changed[0])).run!
        Flows::SyncService.new(PeriodicRoutine.find(changed[1])).run!
      end

      redirect_to @routine, notice: "Routine was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @routine.destroy

    Flows::SyncService.new(@routine).run!
    Flows::SyncService.new(@routine.inverse_callback.routine).run!

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
