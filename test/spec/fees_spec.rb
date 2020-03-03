require_relative '../spec_helper'

describe Fees do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @varopago=VaropagoApi.new(@merchant_id, @private_key)
    @customers=@varopago.create(:customers)
    @cards=@varopago.create(:cards)
    @charges=@varopago.create(:charges)

    @bank_accounts=@varopago.create(:bankaccounts)

    @fees=@varopago.create(:fees)

  end

  after(:all) do
    @customers.delete_all
  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@customers).to respond_to(meth)
    end
  end

  describe '.create' do

    #In order to create a fee a charge should exists
    it 'creates a fee  ' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      @charges.create(charge_hash, customer['id'])
      sleep(50)
      #create customer fee
      fee_hash = FactoryBot.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)

      #performs check
      expect(@fees.all.first['customer_id']).to match customer['id']

      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end

    it 'creates a fee using a json message' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      @charges.create(charge_hash, customer['id'])
      sleep(50)

      #create customer fee using json
      fee_json =%^{"customer_id":"#{customer['id']}","amount":"12.50","description":"Cobro de Comision"}^
      #performs check , it returns json
      expect(@fees.create(fee_json)).to have_json_path('amount')

    end

  end

  describe '.each' do

    it 'iterates over all elements' do
      @fees.each do |fee|
        expect(fee['description']).to match /\s+/
      end
    end

  end
  
  describe '.list' do

    it 'list fees with a given filter' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      @charges.create(charge_hash, customer['id'])
      sleep(50)

      #create customer fee
      fee_hash = FactoryBot.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)
      sleep(50)

      #create customer fee
      fee_hash = FactoryBot.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)


      #performs check
      search_params = VaropagoUtils::SearchParams.new
      search_params.limit = 1
      expect(@fees.list(search_params).size).to eq 1


      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end

  end

  describe '.all' do

    it 'get all fees' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id: card['id'], order_id: card['id'], amount: 4000)
      @charges.create(charge_hash, customer['id'])
      sleep(50)

      #create customer fee
      fee_hash = FactoryBot.build(:fee, customer_id: customer['id'])
      @fees.create(fee_hash)

      #performs check
      expect(@fees.all.first['amount']).to be_a Float

      #cleanup
      @cards.delete(card['id'], customer['id'])
      @customers.delete(customer['id'])

    end
  end
end
