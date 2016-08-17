module Nodered
  class TimeBasedRoutineSerializer < FlowSerializer
    def nodes
      inject_id = SecureRandom.uuid

      actor_id, actor_nodes = object.actor.to_nodes(object.callback.payload, 300, 100)

      [
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
          wires: [[actor_id, event_id]]
        },
        *actor_nodes
      ]
    end
  end
end
