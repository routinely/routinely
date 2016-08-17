class Callback < ActiveRecord::Base
  belongs_to :routine, polymorphic: true
  belongs_to :target, polymorphic: true

  validates :routine, presence: true
  validates :target, presence: true
  validates :delay, numericality: { greater_than: 0 }, allow_nil: true

  validate :resursive?

  scope :on_triggers, -> { where(type: OnTrigger.name) }
  scope :on_exits, -> { where(type: OnExit.name) }

  def target_global_id
    target.try(:to_global_id)
  end

  def to_nodes(x, y)
    target.to_nodes(payload, x, y) # TODO implement #to_nodes for non-Actor targets
  end

  private

  def resursive?
    errors.add(:target, "can't call recursively") if routine == target
  end
end
