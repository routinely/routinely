module Nodered
  class PeriodicRoutineSerializer < FlowSerializer
    def nodes
      rx_id = SecureRandom.uuid
      event_ids = {
        started: SecureRandom.uuid,
        triggered: SecureRandom.uuid
      }

      actor_ids, actor_nodes = [], []

      object.callbacks.each_with_index do |callback, y|
        actor_id, nodes = callback.to_nodes(500, 400 + 100 * y)
        actor_ids << actor_id
        actor_nodes += nodes
      end

      actor_ids.compact!

      listener_id, listener_nodes = Listeners.new(object.rf_listener, object.listeners).to_nodes(actor_ids, event_ids, object, 300, 200)

      [
        {
          id: rx_id,
          x: 100,
          y: 200,
          type: "subflow:#{object.group.rx_subflow}",
          wires: [[listener_id]]
        },
        *listener_nodes,
        *actor_nodes,
        *event_nodes("triggered", event_ids[:triggered], 800, 20),
        *event_nodes("started", event_ids[:started], 800, 60)
      ]
    end

    class Listeners
      def initialize(rf, nrf)
        @rf = rf
        @nrf = nrf
      end

      def to_nodes(actor_ids, event_ids, schedule, x, y)
        timefilter_id = SecureRandom.uuid
        timefilter_node = {
          id: timefilter_id,
          name: "#{schedule.starts_at.to_s(:time)} - #{schedule.ends_at.to_s(:time)}",
          type: "timefilter",
          starthour: schedule.starts_at.hour,
          startmin: schedule.starts_at.min,
          endhour: schedule.ends_at.hour,
          endmin: schedule.ends_at.min,
          sun: schedule.repeats_at?(:sun),
          mon: schedule.repeats_at?(:mon),
          tue: schedule.repeats_at?(:tue),
          wed: schedule.repeats_at?(:wed),
          thu: schedule.repeats_at?(:thu),
          fri: schedule.repeats_at?(:fri),
          sat: schedule.repeats_at?(:sat),
          once: schedule.dependent_routines.on_triggers.any?,
          wires: [[event_ids[:triggered]], [event_ids[:started]], []]
        }

        if @rf.present?
          trigger_mqtt_nodes = if schedule.dependent_routines.on_triggers.any?
            mqtt_id = SecureRandom.uuid
            timefilter_node[:wires][0] << mqtt_id
            mqtt_nodes_for("OnTrigger", mqtt_id, schedule, x + 500, y + 100)
          end

          exit_mqtt_nodes = if schedule.dependent_routines.on_exits.any?
            mqtt_id = SecureRandom.uuid
            timefilter_node[:wires][2] << mqtt_id
            mqtt_nodes_for("OnExit", mqtt_id, schedule, x + 500, y + 140)
          end

          case @nrf.length
          when 0
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[timefilter_id]]
            timefilter_node[:x] = x + 200
            timefilter_node[:y] = y
            timefilter_node[:wires][0] += actor_ids
            return rf_id, [
              rf_node,
              timefilter_node,
              *trigger_mqtt_nodes,
              *exit_mqtt_nodes
            ]
          when 1
            nrf_id, nrf_node = @nrf.first.to_node(x + 150, y)
            nrf_node[:wires] = [[timefilter_id], []]
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[nrf_id]]
            timefilter_node[:x] = x + 300
            timefilter_node[:y] = y
            timefilter_node[:wires][0] += actor_ids
            return rf_id, [
              rf_node,
              nrf_node,
              timefilter_node,
              *trigger_mqtt_nodes,
              *exit_mqtt_nodes
            ]
          when 2
            nrf_1_id, nrf_1_node = @nrf.first.to_node(x + 150, y)
            nrf_2_id, nrf_2_node = @nrf.second.to_node(x + 300, y)
            nrf_1_node[:wires] = [[nrf_2_id], []]
            nrf_2_node[:wires] = [[timefilter_id], []]
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[nrf_1_id]]
            timefilter_node[:x] = x + 450
            timefilter_node[:y] = y
            timefilter_node[:wires][0] += actor_ids
            return rf_id, [
              rf_node,
              nrf_1_node,
              nrf_2_node,
              timefilter_node,
              *trigger_mqtt_nodes,
              *exit_mqtt_nodes
            ]
          end

        else
          trigger_mqtt_nodes = if schedule.dependent_routines.on_triggers.any?
            mqtt_id = SecureRandom.uuid
            actor_ids << mqtt_id
            mqtt_nodes_for("OnTrigger", mqtt_id, schedule, x + 500, y + 100)
          end

          exit_mqtt_nodes = if schedule.dependent_routines.on_exits.any?
            mqtt_id = SecureRandom.uuid
            timefilter_node[:wires][2] << mqtt_id
            mqtt_nodes_for("OnExit", mqtt_id, schedule, x + 500, y + 140)
          end

          if_match_id = SecureRandom.uuid
          else_id = SecureRandom.uuid
          rbe_id = SecureRandom.uuid
          check_id = SecureRandom.uuid

          case @nrf.length
          when 1
            sensor_id, sensor_node = @nrf.first.to_node(x, y)
            sensor_node[:wires] = [[timefilter_id], [else_id]]
            timefilter_node[:x] = x += 150
            timefilter_node[:y] = y - 25
            timefilter_node[:wires][0] += [if_match_id]
            timefilter_node[:wires][1] += [else_id]
            return sensor_id, [
              sensor_node,
              timefilter_node,
              {
                id: if_match_id,
                x: x += 150,
                y: y - 25,
                name: "matched",
                type: "change",
                rules: [
                  {
                    t: "set",
                    p: "payload",
                    pt: "msg",
                    to: "true",
                    tot: "bool"
                  }
                ],
                wires: [[rbe_id]]
              },
              {
                id: else_id,
                x: x,
                y: y + 25,
                name: "otherwise",
                type: "change",
                rules: [
                  {
                    t: "set",
                    p: "payload",
                    pt: "msg",
                    to: "false",
                    tot: "bool"
                  }
                ],
                wires: [[rbe_id]]
              },
              {
                id: rbe_id,
                x: x += 150,
                y: y,
                type: "rbe",
                func: "rbe",
                wires: [[check_id]]
              },
              {
                id: check_id,
                x: x += 150,
                y: y,
                type: "switch",
                property: "payload",
                propertyType: "msg",
                rules: [
                  {
                    t: "true"
                  }
                ],
                checkall: "true",
                outputs: 1,
                wires: [actor_ids]
              },
              *trigger_mqtt_nodes,
              *exit_mqtt_nodes
            ]
          when 2
            sensor_1_id, sensor_1_node = @nrf.first.to_node(x, y)
            sensor_2_id, sensor_2_node = @nrf.second.to_node(x += 150, y - 25)
            sensor_1_node[:wires] = [[sensor_2_id], [else_id]]
            sensor_2_node[:wires] = [[timefilter_id], [else_id]]
            timefilter_node[:x] = x += 150
            timefilter_node[:y] = y - 50
            timefilter_node[:wires][0] += [if_match_id]
            timefilter_node[:wires][1] += [else_id]
            return sensor_1_id, [
              sensor_1_node,
              sensor_2_node,
              timefilter_node,
              {
                id: if_match_id,
                x: x += 150,
                y: y - 50,
                name: "matched",
                type: "change",
                rules: [
                  {
                    t: "set",
                    p: "payload",
                    pt: "msg",
                    to: "true",
                    tot: "bool"
                  }
                ],
                wires: [[rbe_id]]
              },
              {
                id: else_id,
                x: x,
                y: y + 25,
                name: "otherwise",
                type: "change",
                rules: [
                  {
                    t: "set",
                    p: "payload",
                    pt: "msg",
                    to: "false",
                    tot: "bool"
                  }
                ],
                wires: [[rbe_id]]
              },
              {
                id: rbe_id,
                x: x += 150,
                y: y,
                type: "rbe",
                func: "rbe",
                gap: "",
                wires: [[check_id]]
              },
              {
                id: check_id,
                x: x += 150,
                y: y,
                type: "switch",
                property: "payload",
                propertyType: "msg",
                rules: [
                  {
                    t: "true"
                  }
                ],
                checkall: "true",
                outputs: 1,
                wires: [actor_ids]
              },
              *trigger_mqtt_nodes,
              *exit_mqtt_nodes
            ]
          end
        end
      end

      private

      def mqtt_nodes_for(event_type, node_id, schedule, x, y)
        mqtt_id = SecureRandom.uuid

        [
          {
            id: node_id,
            x: x,
            y: y,
            name: "Set MQTT params",
            type: "change",
            rules: [
              {
                t: "set",
                p: "payload",
                pt: "msg",
                to: "",
                tot: "date"
              }
            ],
            wires: [[mqtt_id]]
          },
          {
            id: mqtt_id,
            x: x += 230,
            y: y,
            type: "mqtt out",
            topic: schedule.mqtt_topic_for(event_type),
            broker: schedule.mqtt_broker,
            wires: []
          }
        ]
      end
    end
  end
end
