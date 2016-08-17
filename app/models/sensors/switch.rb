module Sensors
  class Switch < Sensor
    validate -> { errors.add(:kind, "switch sensors are binary") unless binary? }

    def to_nodes(conditions, x, y)
      sensor_id = SecureRandom.uuid

      return sensor_id, {
        id: sensor_id,
        x: x,
        y: y,
        name: "switch",
        type: "switch",
        property: "rf",
        propertyType: "msg",
        rules: [
          {
            t: "eq",
            v: "switch",
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
