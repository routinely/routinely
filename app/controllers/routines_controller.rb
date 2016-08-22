class RoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:edit, :update, :destroy]

  def index
    @time_based_routines = current_user.group.time_based_routines.order(triggers_at: :asc).includes(:actors)
    @rule_based_routines = current_user.group.rule_based_routines
    @periodic_routines = current_user.group.periodic_routines.order(starts_at: :asc)
    @dependent_routines = current_user.group.dependent_routines # TODO order by leading routine's starts_at
  end

  def show
    @routine = Routine.includes(listeners: [:sensor]).find(params[:id])
  end

  def new
    @routine = TimeBasedRoutine.new
  end

  def edit
  end

  def create
    @routine = current_user.group.time_based_routines.build(routine_params)

    if @routine.save
      # Flows::SyncService.new(@routine).run!
      redirect_to @routine, notice: "Routine was successfully created."
    else
      render :new
    end
  end

  def update
    if @routine.update(routine_params)
      # Flows::SyncService.new(@routine).run!
      redirect_to @routine, notice: "Routine was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @routine.destroy
    # Flows::SyncService.new(@routine).run!
    redirect_to routines_url, notice: "Routine was successfully destroyed."
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
    # @routine = GlobalID::Locator.locate(params[:id])
  end

  def routine_params
    params.require(:time_based_routine).permit(:name, :description, :triggers_at, repeats_at: [])

    # params.permit([
    #   TimeBasedRoutine,
    #   RuleBasedRoutine,
    #   PeriodicRoutine,
    #   DependentRoutine
    # ].flat_map(&:attribute_names) - %w(created_at updated_at))
  end
end
