module Nodered
  class FlowSerializer < ActiveModel::Serializer
    include Rails.application.routes.url_helpers

    attributes :label, :nodes

    def label
      object.name
    end

    protected

    def event_nodes(event_type, node_id, x, y)
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
