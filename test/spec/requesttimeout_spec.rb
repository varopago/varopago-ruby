require_relative '../spec_helper'


describe 'Request timeout exception' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @varopago=VaropagoApi.new(@merchant_id, @private_key, false, 0)
    @charges=@varopago.create(:charges)

  end

  it 'raise an VaropagoConnectionException when the operation timeouts' do
    expect{@charges.all}.to raise_error(VaropagoConnectionException)
  end

end
