module Actors
  class Eye < Actor
    delegate :tx_subflow, to: :group

    def to_nodes(payload, x, y)
      actor_id = SecureRandom.uuid
      tx_id = SecureRandom.uuid

      return actor_id, [
        {
          id: actor_id,
          x: x,
          y: y,
          name: "Set eyes color",
          type: "ninja-send",
          d: "eyes",
          da: payload["da"].scan(/\h{6}/).first,
          wires: [[tx_id]]
        },
        {
          id: tx_id,
          x: x += 200,
          y: y,
          type: "subflow:#{tx_subflow}",
          wires: []
        }
      ]
    end
  end
end
