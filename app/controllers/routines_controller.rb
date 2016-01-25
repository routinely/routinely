class RoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:show, :edit, :update, :destroy]

  def index
    @scheduled_routines = Routine.scheduled.order(starts_at: :asc).includes(:users, :sensors, :callback_routines, callbacks: [:target])
    @orphaned_routines = Routine.orphaned.order(created_at: :desc).includes(:users, :sensors)
  end

  def show
  end

  def new
    @routine = Routine.new
  end

  def edit
  end

  def create
    @routine = current_user.group.routines.build(routine_params)

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

  def destroy
    @routine.destroy
    redirect_to routines_url, notice: "Routine was successfully destroyed."
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def routine_params
    params.require(:routine).permit(:name, :description, :starts_at, :ends_at, repeats_at: [], user_ids: [])
  end
end
