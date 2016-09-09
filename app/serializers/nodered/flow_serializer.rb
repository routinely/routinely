module Nodered
  class FlowSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :label, :nodes

    def label
      object.name
    end

    protected

    def comment_node(x = 120, y = 40)
      {
        id: SecureRandom.uuid,
        x: x,
        y: y,
        name: "#{object.model_name.name}/#{object.id}",
        type: "comment",
        wires: []
      }
    end

    def event_nodes(event_type, node_id, x, y)
      http_id = SecureRandom.uuid

      [
        {
          id: node_id,
          x: x,
          y: y,
          name: event_type,
          type: "change",
          rules: [
            {
              t: "delete",
              p: "headers",
              pt: "msg"
            },
            {
              t: "set",
              p: "payload",
              pt: "msg",
              to: {
                event: {
                  kind: event_type,
                  routine_type: object.model_name.name,
                  routine_id: object.id
                }
              }.to_json,
              tot: "json"
            }
          ],
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
