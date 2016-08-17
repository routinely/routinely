module Sensors
  class Humidity < Sensor
    validate -> { errors.add(:kind, "humidity sensors are digital") unless digital? }

    def to_node(conditions, x, y)
      sensor_id = SecureRandom.uuid

      return sensor_id, {
        id: sensor_id,
        x: x,
        y: y,
        name: node_name(conditions),
        type: "switch",
        property: "humi",
        propertyType: "msg",
        rules: node_rules(conditions),
        checkall: "false",
        outputs: 2,
        wires: [[]]
      }
    end

    private

    def node_name(conditions)
      if conditions["gt"].present? && conditions["lt"].present?
        "#{conditions["gt"]}% < H < #{conditions["lt"]}%"
      elsif conditions["gt"].present?
        "#{conditions["gt"]}% < H"
      elsif conditions["lt"].present?
        "H < #{conditions["lt"]}%"
      end
    end

    def node_rules(conditions)
      if conditions["gt"].present? && conditions["lt"].present?
        [
          {
            t: "btwn",
            v: "#{conditions["gt"]}",
            vt: "num",
            v2: "#{conditions["lt"]}",
            v2t: "num"
          },
          {
            t: "else"
          }
        ]
      elsif conditions["gt"].present?
        [
          {
            t: "gt",
            v: "#{conditions["gt"]}",
            vt: "num"
          },
          {
            t: "else"
          }
        ]
      elsif conditions["lt"].present?
        [
          {
            t: "lt",
            v: "#{conditions["lt"]}",
            vt: "num"
          },
          {
            t: "else"
          }
        ]
      end
    end
  end
end
