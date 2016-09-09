module Nodered
  class DependentRoutineSerializer < FlowSerializer
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

      listener_id, listener_nodes = Listeners.new(object.rf_listener, object.listeners).to_nodes(actor_ids, event_ids, object, 300, 200)

      [
        comment_node,
        {
          id: rx_id,
          x: 100,
          y: 200,
          type: "subflow:#{object.group.rx_subflow}",
          wires: [[listener_id]]
        },
        *listener_nodes,
        *actor_nodes,
        *event_nodes("started", event_ids[:started], 1000, 20),
        *event_nodes("triggered", event_ids[:triggered], 1000, 60)
      ]
    end

    class Listeners
      def initialize(rf, nrf)
        @rf = rf
        @nrf = nrf
      end

      def to_nodes(actor_ids, event_ids, schedule, x, y)
        toggle_id = SecureRandom.uuid
        toggle_node = {
          id: toggle_id,
          type: "toggle",
          duration: schedule.duration,
          wires: [actor_ids << event_ids[:triggered]]
        }

        mqtt_nodes = mqtt_nodes_for(schedule.inverse_callback.type, schedule, x - 100, y - 100)
        mqtt_nodes.last[:wires][0] = [event_ids[:started], toggle_id]

        if @rf.present?
          case @nrf.length
          when 0
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[toggle_id]]
            toggle_node[:x] = x + 200
            toggle_node[:y] = y
            return rf_id, [
              rf_node,
              toggle_node,
              *mqtt_nodes
            ]
          when 1
            nrf_id, nrf_node = @nrf.first.to_node(x + 150, y)
            nrf_node[:wires] = [[toggle_id], []]
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[nrf_id]]
            toggle_node[:x] = x + 350
            toggle_node[:y] = y
            return rf_id, [
              rf_node,
              nrf_node,
              toggle_node,
              *mqtt_nodes
            ]
          when 2
            nrf_1_id, nrf_1_node = @nrf.first.to_node(x + 150, y)
            nrf_2_id, nrf_2_node = @nrf.second.to_node(x + 300, y)
            nrf_1_node[:wires] = [[nrf_2_id], []]
            nrf_2_node[:wires] = [[toggle_id], []]
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[nrf_1_id]]
            toggle_node[:x] = x + 500
            toggle_node[:y] = y - 50
            return rf_id, [
              rf_node,
              nrf_1_node,
              nrf_2_node,
              toggle_node,
              *mqtt_nodes
            ]
          end

        else
          if_match_id = SecureRandom.uuid
          else_id = SecureRandom.uuid
          rbe_id = SecureRandom.uuid
          check_id = SecureRandom.uuid

          case @nrf.length
          when 1
            sensor_id, sensor_node = @nrf.first.to_node(x, y)
            sensor_node[:wires] = [[if_match_id], [else_id]]
            toggle_node[:x] = x + 600
            toggle_node[:y] = y - 25
            return sensor_id, [
              sensor_node,
              toggle_node,
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
                wires: [toggle_id]
              },
              *mqtt_nodes,
            ]
          when 2
            sensor_1_id, sensor_1_node = @nrf.first.to_node(x, y)
            sensor_2_id, sensor_2_node = @nrf.second.to_node(x += 150, y - 25)
            sensor_1_node[:wires] = [[sensor_2_id], [else_id]]
            sensor_2_node[:wires] = [[if_match_id], [else_id]]
            toggle_node[:x] = x + 600
            toggle_node[:y] = y - 50
            return sensor_1_id, [
              sensor_1_node,
              sensor_2_node,
              toggle_node,
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
                wires: [[toggle_id]]
              },
              *mqtt_nodes,
            ]
          end
        end
      end

      private

      def mqtt_nodes_for(event_type, schedule, x, y)
        change_id = SecureRandom.uuid

        if schedule.delay.try(&:positive?)
          delay_id = SecureRandom.uuid

          [
            {
              id: SecureRandom.uuid,
              x: x,
              y: y,
              type: "mqtt in",
              topic: schedule.mqtt_topic_for(event_type),
              broker: schedule.mqtt_broker,
              wires: [[delay_id]]
            },
            {
              id: delay_id,
              x: x += 230,
              y: y,
              type: "delay",
              pauseType: "delay",
              timeout: schedule.delay,
              timeoutUnits: "seconds",
              wires: [[change_id]]
            },
            {
              id: change_id,
              x: x += 180,
              y: y,
              name: "Set toggle: true",
              type: "change",
              rules: [
                {
                  t: "set",
                  p: "topic",
                  pt: "msg",
                  to: "toggle",
                  tot: "str"
                },
                {
                  t: "set",
                  p: "payload",
                  pt: "msg",
                  to: "true",
                  tot: "bool"
                }
              ],
              wires: []
            }
          ]
        else
          [
            {
              id: SecureRandom.uuid,
              x: x,
              y: y,
              type: "mqtt in",
              topic: schedule.mqtt_topic_for(event_type),
              broker: schedule.mqtt_broker,
              wires: [[change_id]]
            },
            {
              id: change_id,
              x: x += 230,
              y: y,
              name: "Set toggle: true",
              type: "change",
              rules: [
                {
                  t: "set",
                  p: "topic",
                  pt: "msg",
                  to: "toggle",
                  tot: "str"
                },
                {
                  t: "set",
                  p: "payload",
                  pt: "msg",
                  to: "true",
                  tot: "bool"
                }
              ],
              wires: []
            }
          ]
        end
      end
    end
  end
end
