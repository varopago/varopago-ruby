require 'open_pay_resource'

class Customers < OpenPayResource

  #Bankaccount
  def create_bank_account(customer, bank_account)
    create(bank_account, "#{customer}/bankaccounts")
  end

  def get_bank_account(customer, bank_id)
    get("#{customer}/bankaccounts/#{bank_id}")
  end

  def all_bank_accounts(customer)
    get("#{customer}/bankaccounts/")
  end

  def list_bankaccounts(customer, search_params)
    get("#{customer}/bankaccounts#{search_params.to_s}")
  end

  def each_bank_account(customer)
    get("#{customer}/bankaccounts/").each do |account|
      yield account
    end
  end

  def delete_bank_account(customer, bank_id)
    delete("#{customer}/bankaccounts/#{bank_id}")
  end

  def delete_all_bank_accounts(customer)
    if env == :production
      raise VaropagoException.new('This method is not supported on PRODUCTION', false)
    end
    each_bank_account(customer) do |account|
      delete("#{customer}/bankaccounts/#{account['id']}")
    end
  end

  #Charges
  # customers.create_charge(customer_id,charge)
  def create_charge(customer_id, charge)
    create(charge, "#{customer_id}/charges")
  end

  #gets a charge_id for a given customer_id
  def get_charge(customer_id, charge_id)
    get("#{customer_id}/charges/#{charge_id}")
  end

  def list_charges(customer, search_params)
    get("#{customer}/charges#{search_params.to_s}")
  end

  #return all charges for the given customer_id
  def all_charges(customer_id)
    get("#{customer_id}/charges/")
  end

  def cancel_charge(customer_id, charge_id)
    post(charge_id, "#{customer_id}/charges/#{charge_id}/cancel")
  end

  def refund_charge(customer_id, charge_id, description)
    post(description, "#{customer_id}/charges/#{charge_id}/refund")
  end

  def capture_charge(customer_id, charge_id)
    post('', "#{customer_id}/charges/#{charge_id}/capture")
  end

  def confirm_customer_capture(customer_id, charge_id, amount)
    post(amount, "#{customer_id}/charges/#{charge_id}/capture")
  end

  #Payouts
  def create_payout(customer_id, payout)
    post(payout, "#{customer_id}/payouts")
  end

  def all_payouts(customer_id)
    get("#{customer_id}/payouts")
  end

  def get_payout(customer_id, payout_id)
    get("#{customer_id}/payouts/#{payout_id}")
  end

  def each_payout(customer_id)
    all_payouts(customer_id).each do |pay|
      yield pay
    end
  end

  def list_payouts(customer, search_params)
    get("#{customer}/payouts#{search_params.to_s}")
  end

  #Transfers
  def create_transfer(customer_id, transfer)
    post(transfer, "#{customer_id}/transfers")
  end

  def all_transfers(customer_id)
    get("#{customer_id}/transfers/")
  end

  def list_transfers(customer, search_params)
    get("#{customer}/transfers#{search_params.to_s}")
  end

  def get_transfer(customer_id, transfer_id)
    get("#{customer_id}/transfers/#{transfer_id}")
  end

  def each_transfer(customer_id)
    all_transfers(customer_id).each do |trans|
      yield trans
    end
  end

  #Subscriptions
  def create_subscription(subscription, customer_id)
    #revisar la url
    post(subscription, "#{customer_id}/subscriptions")
  end

  def delete_subscription(customer_id, subscription_id)
    delete("#{customer_id}/subscriptions/#{subscription_id}")
  end

  def get_subscription(customer_id, subscription_id)
    get("#{customer_id}/subscriptions/#{subscription_id}")
  end

  def all_subscriptions(customer_id)
    get("#{customer_id}/subscriptions/")
  end

  def list_subscriptions(customer, search_params)
    get("#{customer}/subscriptions#{search_params.to_s}")
  end

  def each_subscription(customer_id)
    all_subscriptions(customer_id).each do |cust|
      yield cust
    end
  end

  def update_subscription(subscription, customer, params)
    put(params, "#{customer}/subscriptions/#{subscription}")
  end

  def delete_all_subscriptions(customer_id)
    if env == :production
      raise VaropagoException.new('This method is not supported on PRODUCTION', false)
    end
    all_subscriptions(customer_id).each do |sub|
      delete_subscription(customer_id, sub['id'])
    end
  end

  #Card
  def create_card(customer, card)
    create(card, "#{customer}/cards")
  end

  def get_card(customer, card_id)
    get("#{customer}/cards/#{card_id}")
  end

  def delete_card(customer, card_id)
    delete("#{customer}/cards/#{card_id}")
  end

  def delete_all_cards(customer_id)
    if env == :production
      raise VaropagoException.new('This method is not supported on PRODUCTION', false)
    end
    each_card(customer_id) do |card|
      delete_card(customer_id, card['id'])
    end
  end

  def each_card(customer)
    get("#{customer}/cards").each do |card|
      yield card
    end
  end

  def list_cards(customer, search_params)
    get("#{customer}/cards#{search_params.to_s}")
  end

  def all_cards(customer)
    get("#{customer}/cards")
  end

end
