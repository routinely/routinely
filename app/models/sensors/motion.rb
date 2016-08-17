module Sensors
  class Motion < Sensor
    validate -> { errors.add(:kind, "motion sensors are binary") unless binary? }

    def to_nodes(conditions, x, y)
      sensor_id = SecureRandom.uuid

      return sensor_id, {
        id: sensor_id,
        x: x,
        y: y,
        name: "motion",
        type: "switch",
        property: "rf",
        propertyType: "msg",
        rules: [
          {
            t: "eq",
            v: "motion",
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
