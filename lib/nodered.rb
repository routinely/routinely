module Nodered
  class Client
    include HTTParty

    def initialize(host)
      self.class.base_uri host
    end

    def flows
      self.class.get("/flows")
    end
  end

  def self.client(host)
    Client.new(host)
  end
end
