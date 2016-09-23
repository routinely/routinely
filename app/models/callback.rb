class Callback < ActiveRecord::Base
  audited associated_with: :routine

  belongs_to :routine, polymorphic: true
  belongs_to :target, polymorphic: true

  validates :routine, presence: true
  validates :target, presence: true
  validates :delay, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  validate :resursive?

  scope :on_triggers, -> { where(type: OnTrigger.name) }
  scope :on_exits, -> { where(type: OnExit.name) }

  def target_global_id
    target.try(:to_global_id)
  end

  def to_nodes(x, y)
    case target
    when Actor
      delayed(*target.to_nodes(payload, x, y))
    else
      return nil, []
    end
  end

  private

  def resursive?
    errors.add(:target, "can't call recursively") if routine == target
  end

  def delayed(actor_id, actor_nodes)
    if delay.try(&:positive?)
      delay_id = SecureRandom.uuid

      delay_node = {
        id: delay_id,
        x: actor_nodes.first[:x],
        y: actor_nodes.first[:y],
        type: "delay",
        pauseType: "delay",
        timeout: delay,
        timeoutUnits: "seconds",
        wires: [[actor_id]]
      }

      actor_nodes.each { |node| node[:x] += 200 }

      return delay_id, [delay_node, *actor_nodes]

    else
      return actor_id, actor_nodes
    end
  end
end
