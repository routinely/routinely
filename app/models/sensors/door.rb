module Sensors
  class Door < Sensor
    validate -> { errors.add(:kind, "door sensors are binary") unless binary? }

    def to_node(conditions, x, y)
      sensor_id = SecureRandom.uuid

      return sensor_id, {
        id: sensor_id,
        x: x,
        y: y,
        name: "door",
        type: "switch",
        property: "rf",
        propertyType: "msg",
        rules: [
          {
            t: "eq",
            v: "door",
            vt: "str"
          }
        ],
        checkall: "true",
        outputs: 1,
        wires: [[]]
      }
    end
  end
end
