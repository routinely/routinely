class Event < ActiveRecord::Base
  enum kind: %i(started triggered ended)

  belongs_to :routine, polymorphic: true

  validates :routine, presence: true
end
