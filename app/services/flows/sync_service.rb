module Flows
  class SyncService
    def initialize(routine)
      @routine = routine
    end

    def run!
      return unless @routine.group.synced?

      if @routine.persisted?
        if @routine.to_flow.empty?
          client.remove_flow(@routine.flow_id) if @routine.flow_id.present?
          @routine.update(flow_id: nil)
        elsif @routine.flow_id.present?
          client.update_flow(@routine.flow_id, @routine.to_flow)
        else
          response = client.add_flow(@routine.to_flow)
          @routine.update(flow_id: response["id"])
        end
      else # if routine.destroyed?
        client.remove_flow(@routine.flow_id)
      end
    end

    private

    def client
      @client ||= Nodered::Client.new(@routine.group.nodered_host)
    end
  end
end
