class RuleBasedRoutineSerializer < ActiveModel::Serializer
  attributes :id, :title, :allDay, :dow, :class_name

  def title
    object.name
  end

  def allDay
    true
  end

  def dow
    object.repeats_at.to_days_of_week
  end

  def class_name
    "fc-rule-based-routine"
  end
end
