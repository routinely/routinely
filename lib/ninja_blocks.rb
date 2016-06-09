module NinjaBlocks
  class Client
    include HTTParty
    base_uri "https://api.ninja.is/rest/v0"
    default_options.update(verify: false) # NinjaBlocks SSL certificate has expired

    def initialize(token)
      self.class.default_params(user_access_token: token)
    end

    def rules
      self.class.get("/rule")
    end

    def suspend(rule_id)
      self.class.post("/rule/#{rule_id}/suspend")
    end

    def unsuspend(rule_id)
      self.class.delete("/rule/#{rule_id}/suspend")
    end

    def devices
      self.class.get("/devices")
    end

    def add_subdevice(device_id:, category:, type:, name:, data:, url:)
      self.class.post("/device/#{device_id}/subdevice", body: {
        category: category,
        type: type,
        shortName: name,
        data: data,
        url: url
      })
    end

    def data(device_id)
      self.class.get("/device/#{device_id}/data")
    end
  end

  def self.client(token)
    Client.new(token)
  end
end
