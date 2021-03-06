require "administrate/base_dashboard"

class RoutineDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    group: Field::BelongsTo,
    name: Field::String,
    description: Field::Text,
    repeats_at: Field::Bitmask,
    starts_at: Field::Time,
    ends_at: Field::Time,
    duration: Field::Number,
    sensors: Field::HasMany,
    on_triggers: Field::HasMany,
    on_exits: Field::HasMany,
    active: Field::Boolean,
    once: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :group,
    :name,
    :repeats_at,
    :starts_at,
    :created_at,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :group,
    :name,
    :description,
    :repeats_at,
    :starts_at,
    :ends_at,
    :duration,
    :sensors,
    :on_triggers,
    :on_exits,
    :active,
    :once,
  ]

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.

  def display_resource(routine)
    routine.name
  end
end
