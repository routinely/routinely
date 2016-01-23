module RoutinesHelper
  def routine_schedule(routine)
    "#{routine.starts_at.to_formatted_s(:time)} – #{routine.ends_at.to_formatted_s(:time)} #{routine.repeats_at}"
  end
end
