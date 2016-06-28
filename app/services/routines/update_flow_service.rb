module Routines
  class UpdateFlowService
    def initialize(routine)
      @routine = routine
      @client = Nodered.client(routine.group.nodered_host)
    end

    def run!
      response = if @routine.flow_id
        @client.update_flow(@routine.flow_id, @routine.to_flow)
      else
        @client.add_flow(@routine.to_flow)
      end

      @routine.update(flow_id: response["id"]) if response.ok? # TODO: error handling
    end
  end
end
