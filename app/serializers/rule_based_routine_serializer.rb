class RuleBasedRoutineSerializer < ActiveModel::Serializer
  attributes :id, :title, :allDay, :dow

  def title
    object.name
  end

  def allDay
    true
  end

  def dow
    object.repeats_at.to_days_of_week
  end
end
