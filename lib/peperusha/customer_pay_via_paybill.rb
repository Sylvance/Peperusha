require 'active_support'
require 'interactor'
require 'json'

require_relative('./client.rb')

module Peperusha
  class CustomerPayViaPaybill
    include Interactor

    delegate :account_number, :amount, :business_paybill_number, :customer_number, :token, to: :context

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
      errors << 'account_number.missing' if account_number.nil?
      errors << 'amount.missing' if amount.nil?
      errors << 'business_paybill_number.missing' if business_paybill_number.nil?
      errors << 'customer_number.missing' if customer_number.nil?
      errors
    end

    def attributes
      {
        'Amount': amount,
        'BillRefNumber': account_number,
        'CommandID': 'CustomerPayBillOnline',
        'Msisdn': customer_number,
        'ShortCode': business_paybill_number
      }
    end
  end
end
