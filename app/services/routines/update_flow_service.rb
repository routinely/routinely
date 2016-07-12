module Routines
  class UpdateFlowService
    def initialize(routine)
      @routine = routine
      @client = Nodered.client(routine.group.nodered_host)
    end

    def run!
      flow = BuildFlowService.new(@routine).run!

      response = if @routine.flow_id.present?
        @client.update_flow(@routine.flow_id, flow)
      else
        @client.add_flow(flow)
      end

      @routine.update(flow_id: response["id"]) if response.ok? # TODO: error handling
    end
  end
end
