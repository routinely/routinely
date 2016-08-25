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
          y: 300,
          type: "subflow:#{object.group.rx_subflow}",
          wires: [[listener_id]]
        },
        *listener_nodes,
        *actor_nodes,
        *event_nodes("triggered", event_ids[:triggered], 800, 20),
        *event_nodes("started", event_ids[:started], 800, 60),
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
          once: schedule.once?,
          wires: [[event_ids[:triggered]], [event_ids[:started]], []]
        }

        if @rf.present?
          case @nrf.length
          when 0
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[timefilter_id]]
            timefilter_node[:x] = x + 200
            timefilter_node[:y] = y
            timefilter_node[:wires][0] += actor_ids
            return rf_id, [rf_node, timefilter_node]
          when 1
            nrf_id, nrf_node = @nrf.first.to_node(x + 150, y)
            nrf_node[:wires] = [[timefilter_id], []]
            rf_id, rf_node = @rf.to_node(x, y)
            rf_node[:wires] = [[nrf_id]]
            timefilter_node[:x] = x + 300
            timefilter_node[:y] = y
            timefilter_node[:wires][0] += actor_ids
            return rf_id, [rf_node, nrf_node, timefilter_node]
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
            return rf_id, [rf_node, nrf_1_node, nrf_2_node, timefilter_node]
          end

        else
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
              }
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
              }
            ]
          end
        end
      end
    end
  end
end
