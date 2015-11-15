class Callback < ActiveRecord::Base
  belongs_to :routine
  belongs_to :target, polymorphic: true

  validates :routine, presence: true, uniqueness: { scope: [:type, :target_type, :target_id] }
  validates :target, presence: true
  validates :delay, numericality: { greater_than: 0 }, allow_nil: true

  validate :resursive?

  def resursive?
    errors.add(:target, "can't call recursively") if routine == target
  end
end
