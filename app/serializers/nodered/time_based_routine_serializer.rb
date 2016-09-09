module Nodered
  class TimeBasedRoutineSerializer < FlowSerializer
    def nodes
      inject_id = SecureRandom.uuid
      event_id = SecureRandom.uuid

      actor_ids, actor_nodes = [], []

      object.callbacks.each_with_index do |callback, y|
        actor_id, nodes = callback.to_nodes(300, 200 + 100 * y)
        actor_ids << actor_id
        actor_nodes += nodes
      end

      [
        comment_node,
        {
          id: inject_id,
          x: 100,
          y: 100,
          name: object.triggers_at.to_s(:time),
          type: "inject",
          topic: "",
          payload: "",
          payloadType: "date",
          repeat: "",
          crontab: object.crontab,
          once: false,
          wires: [actor_ids << event_id]
        },
        *actor_nodes,
        *event_nodes("triggered", event_id, 300, 100)
      ]
    end
  end
end
