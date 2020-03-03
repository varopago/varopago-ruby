require 'logger'
require 'base64'
require 'rest-client'
require 'uri'

require 'varopago/open_pay_resource_factory'
require 'errors/varopago_exception'

LOG= Logger.new(STDOUT)
#change to Logger::DEBUG if need trace information
#due the nature of the information, we recommend to never use a log file when in debug
LOG.level=Logger::FATAL

class VaropagoApi
  #API Endpoints
  API_DEV='https://sandbox-api.varopago.mx/v1/'
  API_PROD='https://api.varopago.mx/v1/'

  #by default testing environment is used
  def initialize(merchant_id, private_key, production=false, timeout=90)
    @merchant_id=merchant_id
    @private_key=private_key
    @production=production
    @timeout=timeout
  end

  def create(resource)
    klass=OpenPayResourceFactory::create(resource, @merchant_id, @private_key, @production, @timeout)
    klass.api_hook=self
    klass
  end

  def VaropagoApi::base_url(production)
    if production
      API_PROD
    else
      API_DEV
    end
  end

  def env
    if @production
      :production
    else
      :test
    end
  end

end
