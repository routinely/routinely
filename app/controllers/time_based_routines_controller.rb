class TimeBasedRoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:show, :edit, :update, :destroy, :events]

  def show
  end

  def new
    @routine = TimeBasedRoutine.new
  end

  def edit
  end

  def create
    @routine = current_user.group.time_based_routines.build(routine_params)

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

  def events
    @events = @routine.events.page(params[:page])

    respond_to do |format|
      format.js { render partial: "events/events" }
    end
  end

  private

  def set_routine
    @routine = TimeBasedRoutine.find(params[:id])
    authorize @routine
  end

  def routine_params
    params.require(:time_based_routine).permit(:name, :description, :triggers_at, repeats_at: [])
  end
end
