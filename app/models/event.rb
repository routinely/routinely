class Event < ActiveRecord::Base
  paginates_per 10

  enum kind: %i(started triggered ended)

  belongs_to :routine, polymorphic: true

  validates :routine, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :during_current_week, -> { where(created_at: Time.now.beginning_of_week(:sunday)..Time.now.end_of_week(:sunday)) }
end
