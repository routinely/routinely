class Routine < ActiveRecord::Base
  belongs_to :group

  has_many :listeners, dependent: :destroy
  has_many :sensors, through: :listeners
  has_many :on_triggers, dependent: :destroy
  has_many :on_exits, dependent: :destroy

  bitmask :repeats_at, as: %i(mon tue wed thu fri sat sun) do
    def to_s
      map { |d| d.to_s.capitalize }.join("/")
    end
  end

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :ends_at, numericality: { greater_than: :starts_at }, allow_nil: true, if: :starts_at?
  validates :duration, inclusion: { in: 0..24.hours }, allow_nil: true
  validates :group, presence: true
end
