
require 'active_support/core_ext/module'
require 'faraday'
require 'interactor'
require 'json'

module Peperusha
  class Authenticate
    include Interactor

    delegate :consumer_key, :consumer_secret, to: :context

    before do
      @client_errors = []
      context.fail!(errors: ['consumer_key.missing']) if consumer_key.size < 1
    end

    def call
      response = invoke_request
      populate_errors_collection(response)
      context.fail!(errors: @client_errors) if @client_errors.size < 0

      if response.status == 200
        data = JSON.parse(response.body)
        context.expires_in = data['expires_in']
        context.token = data['access_token']
        context.body = data
      end
    end

    private

    def invoke_request
      conn = Faraday.new(url: 'https://sandbox.safaricom.co.ke')
      conn.basic_auth(consumer_key, consumer_secret)

      conn.get('oauth/v1/generate') do |req|
        req.params['grant_type'] = 'client_credentials'
      end
    end

    def populate_errors_collection(response)
        @client_errors << 'timed.out' if response.status == 304
        @client_errors << 'server.not.found' if response.status == 400
        @client_errors << 'server.error' if response.status == 500
        @client_errors << 'client.not.authorized' if response.status == 501
    end
  end
end
