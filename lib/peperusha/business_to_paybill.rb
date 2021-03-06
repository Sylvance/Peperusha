require 'active_support'
require 'interactor'
require 'json'

require_relative('./client.rb')

module Peperusha
  class BusinessToPaybill
    include Interactor

    delegate :account_reference, :amount, :business_number1, :business_number2, :initiator_name, :remarks, :result_url, :security_credential, :timeout_url, :token, to: :context

    before do
      missing_params_errors = check_if_params_missing
      context.fail!(errors: missing_params_errors) if missing_params_errors.size > 0
    end

    def call
      path = 'mpesa/b2b/v1/paymentrequest'
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
      errors << 'token.missing' if token.nil?
      errors << 'amount.missing' if amount.nil?
      errors << 'business_number1.missing' if business_number1.nil?
      errors << 'business_number2.missing' if business_number2.nil?
      errors << 'account_reference.missing' if account_reference.nil?
      errors << 'security_credential.missing' if security_credential.nil?
      errors
    end

    def attributes
      result_url = nil if result_url.nil?
      timeout_url = nil if timeout_url.nil?
      {
        'AccountReference': account_reference,
        'Amount': amount,
        'CommandID': 'BusinessPayBill',
        'Initiator': initiator_name,
        'Occasion': 'Generated by peperusha',
        'PartyA': business_number1,
        'PartyB': business_number2,
        'RecieverIdentifierType': '4',
        'Remarks': remarks,
        'ResultURL': result_url,
        'SecurityCredential': security_credential,
        'SenderIdentifierType': '4',
        'QueueTimeOutURL': timeout_url
      }
    end
  end
end
