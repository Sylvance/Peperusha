require 'active_support'
require 'interactor'
require 'json'

require_relative('./client.rb')

module Peperusha
  class Authenticate
    include Interactor

    delegate :consumer_key, :consumer_secret, to: :context

    before do
      missing_params_errors = check_if_params_missing
      context.fail!(errors: missing_params_errors) if missing_params_errors.size > 0
    end

    def call
      response = Peperusha::Client.invoke_token_request(consumer_key, consumer_secret)

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
      errors << 'consumer_key.missing' if consumer_key.nil?
      errors << 'consumer_secret.missing' if consumer_secret.nil?
      errors
    end
  end
end
