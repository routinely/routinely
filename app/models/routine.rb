class Routine < ActiveRecord::Base
  has_many :listeners, dependent: :destroy
  has_many :sensors, through: :listeners

  bitmask :repeats_at, as: %i(mon tue wed thu fri sat sun) do
    def to_s
      map { |d| d.to_s.capitalize }.join("/")
    end
  end

  validates :name, presence: true
  validates :ends_at, numericality: { greater_than: :starts_at }, allow_nil: true, if: :starts_at?
  validates :duration, inclusion: { in: 0..24.hours }, allow_nil: true
end
