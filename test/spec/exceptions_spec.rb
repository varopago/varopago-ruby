require '../spec_helper'


describe 'Openpay Exceptions' do


  before(:all) do


    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    @openpay=OpenpayApi.new(@merchant_id, @private_key)
    @customers=@openpay.create(:customers)
    @cards=@openpay.create(:cards)


  end

  describe OpenpayException do


    it 'should raise an OpenpayException when a non given resource is passed to the api factory' do
     expect { @openpay.create(:foo) }.to raise_exception OpenpayException
    end

    it 'should raise an OpenpayException when the delete_all method is used on production' do
      @openpayprod=OpenpayApi.new(@merchant_id,@private_key,true)
      cust=@openpayprod.create(:customers)
      expect { cust.delete_all }.to raise_exception OpenpayException
    end


  end


  describe OpenpayTransactionException do

    it 'should fail when an invalid field-value is passed in *email' do
      #invalid email format
      email='foo'
      customer_hash = FactoryGirl.build(:customer, email: email)

      #perform checks
      expect { @customers.create(customer_hash) }.to raise_exception OpenpayTransactionException
      begin
        @customers.create(customer_hash)
      rescue OpenpayTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 400
        expect(e.error_code).to be 1001
        expect(e.description).to match 'email\' not a well-formed email address'
        expect(e.json_body).to have_json_path('category')
      end
    end


    it ' raise  an OpenpayTransactionException when trying to delete a non existing bank account '  do
      #non existing resource
      #perform checks
      expect { @customers.delete('1111') }.to raise_exception  OpenpayTransactionException
      begin
        @customers.delete('1111')
      rescue OpenpayTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 404
        expect(e.error_code).to be 1005
        expect(e.description).to match "The customer with id '1111' does not exist"
        expect(e.json_body).to have_json_path('category')
      end
    end



    it 'fails when trying to create an existing card' do

      #create customer
      customers=@openpay.create(:customers)
      customer_hash = FactoryGirl.build(:customer, name: 'Juan', last_name: 'Perez')
      customer=customers.create(customer_hash)
      #create card using json
      card_json = FactoryGirl.build(:valid_card).to_json
      card=@cards.create(card_json)
      #perform check
      expect { @cards.create(card_json) }.to raise_error(OpenpayTransactionException)

      #cleanup
      @customers.delete(customer['id'])
      card_hash=JSON.parse card
      @cards.delete card_hash['id']
    end


    it 'raise  an OpenpayTransactionException when using an expired card' do
      card_hash = FactoryGirl.build(:expired_card)
      expect { @cards.create(card_hash) }.to raise_error(OpenpayTransactionException)
      begin
        @cards.create(card_hash)
      rescue OpenpayTransactionException =>   e
        expect(e.description).to match 'The card has expired.'
        expect(e.error_code).to be 3002

      end

    end


  end


  describe OpenpayConnectionException do

    it 'raise an OpenpayConnectionException when provided credentials are invalid' do

      merchant_id='santa'
      private_key='invalid'

      openpay=OpenpayApi.new(merchant_id, private_key)
      customers=openpay.create(:customers)
      expect { customers.delete('1111') }.to raise_exception  OpenpayConnectionException


      begin
        customers.delete('1111')
      rescue OpenpayConnectionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 401
        expect(e.error_code).to be 1002
        expect(e.description).to match 'The api key or merchant id are invalid.'
        expect(e.json_body).to have_json_path('category')
      end


    end
  end


end