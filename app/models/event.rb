class Event < ActiveRecord::Base
  paginates_per 10

  enum kind: %i(started triggered ended)

  belongs_to :routine, polymorphic: true

  validates :routine, presence: true
end
