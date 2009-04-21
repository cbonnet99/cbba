def xero
  XeroGatewaySingleton.instance
end

class XeroGatewaySingleton
  include Singleton
  
  #Read the API key config for the current ENV
  unless File.exist?(RAILS_ROOT + '/config/xero.yml')
    raise XeroAPIKeyConfigFileNotFoundException.new("File RAILS_ROOT/config/xero.yml not found")
  else
    env = ENV['RAILS_ENV'] || RAILS_ENV
    XERO_API_KEY = YAML.load_file(RAILS_ROOT + '/config/xero.yml')[env]
  end
          
  def gateway  
    XeroGateway::Gateway.new(
      :customer_key => XERO_API_KEY["customer_key"],
      :api_key => XERO_API_KEY["api_key"],
      :xero_url => XERO_API_KEY["xero_url"]
      )
  end
end