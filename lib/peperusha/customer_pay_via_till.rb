require 'active_support'
require 'interactor'
require 'json'

require_relative('./client.rb')

module Peperusha
  class CustomerPayViaTill
    include Interactor

    delegate :amount, :business_till_number, :customer_number, :token, to: :context

    before do
      missing_params_errors = check_if_params_missing
      context.fail!(errors: missing_params_errors) if missing_params_errors.size > 0
    end

    def call
      path = 'mpesa/c2b/v1/simulate'
      response = Peperusha::Client.invoke_post_request(token, path, attributes)

      if response.status == 200
        data = JSON.parse(response.body)
        context.body = data
      else
        client_errors = Peperusha::Client.build_errors_collection(response)
        context.fail!(errors: client_errors)
      end
    end

    private

    def check_if_params_missing
      errors = []
      errors << 'amount.missing' if amount.nil?
      errors << 'business_till_number.missing' if business_till_number.nil?
      errors << 'customer_number.missing' if customer_number.nil?
      errors
    end

    def attributes
      {
        'Amount': amount,
        'CommandID': 'CustomerBuyGoodsOnline:',
        'Msisdn': customer_number,
        'ShortCode': business_till_number
      }
    end
  end
end
