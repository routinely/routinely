module Actors
  class Socket < Actor
    delegate :tx_subflow, to: :group

    def to_nodes(payload, x, y)
      actor_id = SecureRandom.uuid
      socket_id = SecureRandom.uuid

      return actor_id, [
        {
          id: actor_id,
          x: x,
          y: y,
          name: "Turn socket #{payload["da"] == "0xdadada" ? "on" : "off"}",
          type: "ninja-send",
          d: "rf",
          da: payload["da"], # 0xdadada for on, 0xdadad2 for off
          wires: [[socket_id]]
        },
        {
          id: socket_id,
          x: x += 200,
          y: y,
          type: "subflow:#{tx_subflow}",
          wires: []
        }
      ]
    end
  end
end
