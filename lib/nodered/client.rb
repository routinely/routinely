module Nodered
  class Client
    include HTTParty

    def initialize(host)
      self.class.base_uri host
    end

    def flows
      self.class.get("/flows")
    end

    def add_flow(flow)
      self.class.post("/flow", body: flow.to_json, headers: { "Content-Type" => "application/json" }).tap do |response|
        Rollbar.error(NoderedError.new("Failed to add flow"), flow: flow) unless response.success?
      end
    end

    def update_flow(id, flow)
      self.class.put("/flow/#{id}", body: flow.to_json, headers: { "Content-Type" => "application/json" }).tap do |response|
        Rollbar.error(NoderedError.new("Failed to update flow #{id}"), flow: flow) unless response.success?
      end
    end

    def remove_flow(id)
      self.class.delete("/flow/#{id}").tap do |response|
        Rollbar.error(NoderedError.new("Failed to remove flow #{id}")) unless response.success?
      end
    end
  end

  class NoderedError < StandardError; end
end
