#varopago version
require 'version'

#external dependencies
require 'rest-client'
require 'json'

module Varopago

  #api setup / constants
  require 'varopago/varopago_api'

  #base class
  require 'varopago/open_pay_resource'

  #resource classes
  require 'varopago/points'
  require 'varopago/tokens'
  require 'varopago/bankaccounts'
  require 'varopago/cards'
  require 'varopago/charges'
  require 'varopago/customers'
  require 'varopago/fees'
  require 'varopago/payouts'
  require 'varopago/plans'
  require 'varopago/subscriptions'
  require 'varopago/transfers'
  require 'varopago/charges'
  require 'varopago/webhooks'

  #misc
  require 'varopago/utils/search_params'

  #exceptions
  require 'errors/varopago_exception_factory'
  require 'errors/varopago_exception'
  require 'errors/varopago_transaction_exception'
  require 'errors/varopago_connection_exception'

  include VaropagoUtils
end
