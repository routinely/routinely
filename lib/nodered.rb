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
      self.class.post("/flow", body: flow.to_json, headers: { "Content-Type" => "application/json" })
    end

    def update_flow(id, flow)
      self.class.put("/flow/#{id}", body: flow.to_json, headers: { "Content-Type" => "application/json" })
    end

    def remove_flow(id)
      self.class.delete("/flow/#{id}")
    end
  end

  def self.client(host)
    Client.new(host)
  end
end
