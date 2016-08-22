module Nodered
  class TimeBasedRoutineSerializer < FlowSerializer
    include Rails.application.routes.url_helpers

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
        *event_nodes(event_id, 300, 100)
      ]
    end

    private

    def event_nodes(node_id, x, y)
      http_id = SecureRandom.uuid

      [
        {
          id: node_id,
          x: x,
          y: y,
          name: "Set request params",
          type: "change",
          rules: [
            {
              t: "set",
              p: "payload",
              pt: "msg",
              to: {
                event: {
                  type: "TimeBasedRoutine",
                  routine_id: object.id
                }
              }.to_json,
              tot: "json"
            }
          ],
          action: "",
          property: "",
          from: "",
          to: "",
          reg: false,
          wires: [[http_id]]
        },
        {
          id: http_id,
          x: x += 200,
          y: y,
          name: "POST #{api_events_path}",
          type: "http request",
          method: "POST",
          ret: "txt",
          url: api_events_url,
          wires: [[]]
        }
      ]
    end
  end
end
