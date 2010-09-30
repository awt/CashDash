require 'singleton'
class MixpanelClient
  include Singleton
  def get_client
    if @client.nil?
      mixpanel_config = CashDash::Config.instance.get_config['mixpanel']
      @client = Mixpanel::Client.new({:api_key => mixpanel_config['api_key'], 
                                      :api_secret => mixpanel_config['api_secret']})
    else
      @client
    end
  end
end
