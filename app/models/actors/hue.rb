module Actors
  class Hue < Actor
    store_accessor :config, :device_id, :server_id

    def to_nodes(payload, x, y)
      actor_id = SecureRandom.uuid
      hue_id = SecureRandom.uuid

      params = {}
      params[:on] = [payload["on"] == "true"] unless payload["on"].blank? # true, false
      params[:bri] = [payload["bri"].to_i] unless payload["bri"].blank? # 0-255
      params[:rgb] = [payload["rgb"].scan(/\d{1,3},\d{1,3},\d{1,3}/).first.split(",").map(&:to_i)] unless payload["rgb"].blank? # 0-255

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
              to: params.to_json,
              tot: "json"
            }
          ],
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
