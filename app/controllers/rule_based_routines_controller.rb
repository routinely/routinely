class RuleBasedRoutinesController < ApplicationController
  before_action :require_login
  before_action :set_routine, only: [:edit, :update, :destroy]

  def show
    @routine = RuleBasedRoutine.find(params[:id])
  end

  def new
    @routine = RuleBasedRoutine.new
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
    @routine = RuleBasedRoutine.find(params[:id])
  end

  def routine_params
    params.require(:rule_based_routine).permit(:name, :description, repeats_at: [])
  end
end
