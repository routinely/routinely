class Event < ActiveRecord::Base
  enum kind: %i(started triggered ended)

  belongs_to :routine, counter_cache: true

  validates :routine, presence: true
end
