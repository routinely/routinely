class RoutinePolicy
  attr_reader :user, :routine

  def initialize(user, routine)
    @user = user
    @routine = routine
  end

  def show?
    routine.group == current_group
  end

  def edit?
    routine.group == current_group
  end

  def update?
    routine.group == current_group
  end

  def destroy?
    routine.group == current_group
  end

  def events?
    routine.group == current_group
  end

  private

  def current_group
    user.group
  end
end
