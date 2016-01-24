class Routine < ActiveRecord::Base
  belongs_to :group

  has_many :listeners, dependent: :destroy
  has_many :sensors, through: :listeners
  has_many :on_triggers, dependent: :destroy
  has_many :on_exits, dependent: :destroy

  has_one :inverse_callback, -> { where(target_type: "Routine") }, foreign_key: :target_id, class_name: "Callback", dependent: :destroy
  has_one :lead, through: :inverse_callback, source: :routine

  has_many :tags, dependent: :destroy
  has_many :users, through: :tags

  bitmask :repeats_at, as: %i(mon tue wed thu fri sat sun) do
    def to_s
      map { |d| d.to_s.capitalize }.join("/")
    end
  end

  validates :name, presence: true, uniqueness: { scope: :group }
  validates :starts_at, presence: true, if: :ends_at?
  validate -> { errors.add(:ends_at, "should be greater than starts_at") if ends_at.try(:<=, starts_at) }, if: :starts_at?
  validates :duration, inclusion: { in: 0..24.hours }, allow_nil: true
  validates :group, presence: true

  scope :scheduled, -> { where.not(starts_at: nil) }
  scope :dependent, -> { where(starts_at: nil) }
  scope :orphaned, -> { dependent.where(<<-SQL.squish
    NOT EXISTS(
      SELECT 1 FROM callbacks
      WHERE callbacks.target_type = 'Routine'
      AND callbacks.target_id = routines.id
    )
    SQL
  )}
end
