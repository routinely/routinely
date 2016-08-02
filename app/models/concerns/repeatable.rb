module Repeatable
  extend ActiveSupport::Concern

  included do
    bitmask :repeats_at, as: %i(mon tue wed thu fri sat sun), null: false
    validates :repeats_at, presence: true, numericality: { greater_than: 0 }
  end
end
