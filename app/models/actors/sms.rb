module Actors
  class Sms < Actor
    store_accessor :config, :twilio_api

    def to_nodes(payload, x, y)
      actor_id = SecureRandom.uuid
      twilio_id = SecureRandom.uuid

      return actor_id, [
        {
          id: actor_id,
          x: x,
          y: y,
          name: "Set SMS fields",
          type: "change",
          rules: [
            {
              t: "set",
              p: "payload",
              pt: "msg",
              to: payload["message"]
              tot: "str"
            }
          ],
          action: "",
          property: "",
          from: "",
          to: "",
          reg: false,
          wires: [[twilio_id]]
        },
        {
          id: twilio_id,
          x: x += 200,
          y: y,
          name: "Send to #{payload["receipient"]}",
          type: "twilio out",
          twilio: twilio_api,
          twilioType: "sms",
          url: "",
          number: payload["receipient"],
          wires: []
        }
      ]
    end
  end
end
