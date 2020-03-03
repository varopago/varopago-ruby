require_relative '../spec_helper'

describe 'Varopago Exceptions' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @varopago=VaropagoApi.new(@merchant_id, @private_key)
    @customers=@varopago.create(:customers)
    @cards=@varopago.create(:cards)

  end

  describe VaropagoException do

    it 'should raise an VaropagoException when a non given resource is passed to the api factory' do
     expect { @varopago.create(:foo) }.to raise_exception VaropagoException
    end

    it 'should raise an VaropagoException when the delete_all method is used on production' do
      @varopagoprod=VaropagoApi.new(@merchant_id,@private_key,true)
      cust=@varopagoprod.create(:customers)
      expect { cust.delete_all }.to raise_exception VaropagoException
    end

  end

  describe VaropagoTransactionException do

    it 'should fail when an invalid field-value is passed in *email' do
      #invalid email format
      email='foo'
      customer_hash = FactoryBot.build(:customer, email: email)

      #perform checks
      expect { @customers.create(customer_hash) }.to raise_exception VaropagoTransactionException
      begin
        @customers.create(customer_hash)
      rescue VaropagoTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 400
        expect(e.error_code).to be 1001
        #expect(e.description).to match 'not a well-formed email address'
        expect(e.json_body).to have_json_path('category')
      end
    end

    it ' raise  an VaropagoTransactionException when trying to delete a non existing bank account '  do
      #non existing resource
      #perform checks
      expect { @customers.delete('1111') }.to raise_exception  VaropagoTransactionException
      begin
        @customers.delete('1111')
      rescue VaropagoTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 404
        expect(e.error_code).to be 1005
        expect(e.description).to match "The customer with id '1111' does not exist"
        expect(e.json_body).to have_json_path('category')
      end
    end

    it 'raise  an VaropagoTransactionException when using an expired card' do
      card_hash = FactoryBot.build(:expired_card)
      expect { @cards.create(card_hash) }.to raise_error(VaropagoTransactionException)
      begin
        @cards.create(card_hash)
      rescue VaropagoTransactionException => e
        expect(e.description).to match 'The card has expired'
        expect(e.error_code).to be 3002
      end

    end

  end

  describe VaropagoConnectionException do

    it 'raise an VaropagoConnectionException when provided credentials are invalid' do

      merchant_id='santa'
      private_key='invalid'

      varopago=VaropagoApi.new(merchant_id, private_key)
      customers=varopago.create(:customers)
      expect { customers.delete('1111') }.to raise_exception  VaropagoConnectionException

      begin
        customers.delete('1111')
      rescue VaropagoConnectionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 401
        expect(e.error_code).to be 1002
        expect(e.description).to match 'The api key or merchant id are invalid'
        expect(e.json_body).to have_json_path('category')
      end

    end
  end

end
