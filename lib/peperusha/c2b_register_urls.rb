require 'active_support'
require 'interactor'
require 'json'

require_relative('./client.rb')

module Peperusha
  class C2bRegisterUrls
    include Interactor

    delegate :business_number, :confirmation_url, :token, :validation_url, to: :context

    before do
      missing_params_errors = check_if_params_missing
      context.fail!(errors: missing_params_errors) if missing_params_errors.size > 0
    end

    def call
      path = 'mpesa/c2b/v1/registerurl'
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
      errors << 'confirmation_url.missing' if confirmation_url.nil?
      errors << 'business_number.missing' if business_number.nil?
      errors
    end

    def attributes
      {
        'ConfirmationURL': confirmation_url,
        'ResponseType': 'Canceled',
        'ShortCode': business_number,
        'ValidationURL': validation_url
      }
    end
  end
end
