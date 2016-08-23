module Actors
  class Hue < Actor
    store_accessor :config, :device_id, :server_id

    def to_nodes(payload, x, y)
      actor_id = SecureRandom.uuid
      hue_id = SecureRandom.uuid

      return actor_id, [
        {
          id: actor_id,
          x: x,
          y: y,
          name: "Set Hue parameters",
          type: "change",
          rules: [
            {
              t: "set",
              p: "payload",
              pt: "msg",
              to: {
                on: [payload["on"]], # true, false
                bri: [payload["bri"]], # 0-255
                hue: [payload["r"], payload["g"], payload["b"]] # 0-255
              }.to_json,
              tot: "json"
            }
          ],
          action: "",
          property: "",
          from: "",
          to: "",
          reg: false,
          wires: [[hue_id]]
        },
        {
          id: hue_id,
          x: x += 200,
          y: y,
          type: "Hue Set",
          deviceid: device_id,
          serverid: server_id,
          wires: [[], []]
        }
      ]
    end
  end
end
