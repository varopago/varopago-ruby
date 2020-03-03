require_relative '../spec_helper'

describe Transfers do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @varopago=VaropagoApi.new(@merchant_id, @private_key)
    @customers=@varopago.create(:customers)
    @cards=@varopago.create(:cards)
    @charges=@varopago.create(:charges)

    @bank_accounts=@varopago.create(:bankaccounts)
    @transfers=@varopago.create(:transfers)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@bank_accounts).to respond_to(meth)
    end
  end

  describe '.create' do

    it 'transfers money from customer to customer' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)
      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #create customer  2
      customer_hash= FactoryBot.build(:customer,name: 'Alejandro')
      customer2=@customers.create(customer_hash)

      sleep(50)
      #create new transfer
      customer_hash= FactoryBot.build(:transfer,customer_id: customer2['id'])
      transfer=@transfers.create(customer_hash,customer['id'])
      t=@transfers.get(transfer['id'],customer['id'])
      
      expect(t['amount']).to be_within(0.1).of 12.5
      expect(t['method']).to match 'customer'

      #clanup
      @cards.delete_all(customer['id'])

    end

  end

  describe 'get' do

    it 'gets a customer transfer' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #create customer  2
      customer_hash= FactoryBot.build(:customer,name: 'Alejandro')
      customer2=@customers.create(customer_hash)
      
      sleep(50)
      #create new transfer
      customer_hash= FactoryBot.build(:transfer,customer_id: customer2['id'])

      transfer=@transfers.create(customer_hash,customer['id'])
      t=@transfers.get(transfer['id'],customer['id'])
      expect(t).to be_a Hash
      expect(t['amount']).to be_within(0.1).of 12.5
      expect(t['method']).to match 'customer'

      #clanup
      @cards.delete_all(customer['id'])

    end

    it 'fails to get a non existing transfer' do
      expect {   @transfers.get(11111,11111)  }.to raise_exception    VaropagoTransactionException
    end

  end
  describe '.each' do

    it 'iterates over a given customer transfers'  do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #create customer  2
      customer_hash= FactoryBot.build(:customer,name: 'Alejandro')
      customer2=@customers.create(customer_hash)

      sleep(50)
      #create new transfer
      customer_hash= FactoryBot.build(:transfer,customer_id: customer2['id'])
      transfer=@transfers.create(customer_hash,customer['id'])

      #iterates over transfers
      @transfers.each(customer2['id'])  do |tran|
        expect(tran['amount']).to be_within(0.1).of 12.5
        expect(tran['method']).to match 'customer'
      end

      #clanup
      @cards.delete_all(customer['id'])

    end
  end

  describe '.list' do

    it 'list all transfers under the given filter' do


      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])

      #create customer  2
      customer_hash= FactoryBot.build(:customer,name: 'Alejandro')
      customer2=@customers.create(customer_hash)
      
      sleep(50)
      #create new transfer
      customer_hash= FactoryBot.build(:transfer,customer_id: customer2['id'])
      transfer=@transfers.create(customer_hash,customer['id'])
      transfer=@transfers.create(customer_hash,customer['id'])

      #returns all transfers
      @transfers.all(customer2['id'])
      expect(@transfers.all(customer2['id']).size ).to be 2

      search_params = VaropagoUtils::SearchParams.new
      search_params.limit = 1
      expect(@transfers.list(search_params,customer['id']).size).to eq 1


      #cleanup
      @cards.delete_all(customer['id'])
      @cards.delete_all(customer2['id'])

    end

  end

  describe '.all' do

    it 'returns all customer transfers' do

      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create new customer card
      card_hash=FactoryBot.build(:valid_card)
      card=@cards.create(card_hash, customer['id'])

      #create charge
      charge_hash=FactoryBot.build(:card_charge, source_id:card['id'],order_id: card['id'])
      charge=@charges.create(charge_hash,customer['id'])


      #create customer  2
      customer_hash= FactoryBot.build(:customer,name: 'Alejandro')
      customer2=@customers.create(customer_hash)
      
      sleep(50)

      #create new transfer
      customer_hash= FactoryBot.build(:transfer,customer_id: customer2['id'])
      transfer=@transfers.create(customer_hash,customer['id'])


      #returns all transfers
      @transfers.all(customer2['id'])
      expect(@transfers.all(customer2['id']).size ).to be 1

      #cleanup
      @cards.delete_all(customer['id'])

    end

  end
  
end
