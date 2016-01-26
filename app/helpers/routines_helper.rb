module RoutinesHelper
  def routine_schedule(routine)
    if routine.scheduled?
      "#{routine.starts_at.to_formatted_s(:time)} – #{routine.ends_at.to_formatted_s(:time)}"
    elsif routine.orphan?
      "for #{routine.duration}"
    else
      "after #{routine.inverse_callback.delay || 0}, for #{routine.duration}"
    end
  end
end
