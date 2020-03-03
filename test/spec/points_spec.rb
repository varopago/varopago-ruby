require_relative '../spec_helper'

describe 'Points' do

  before(:all) do

    @merchant_id='mhbzmkji20dhu9kq3r2i'
    @private_key='sk_0070ce5a12d948e0a0c9b5b8b7ff51ae'

    @varopago=VaropagoApi.new(@merchant_id,@private_key)
    @points=@varopago.create(:points)

  end

  after(:all) do

  end

  describe '.get' do
    it 'Card Points ' do
      point=@points.getPointsBalance('ka2fi3h6ikppavewn5ne')
      puts point.to_s
    end
  end

end