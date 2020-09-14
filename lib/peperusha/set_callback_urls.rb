require "faraday"
require "interactor"

module Peperusha
  class SetCallbackUrls
    include Interactor

    delegate :secret, :token, to: :context

    before do
      @client_errors = []
      context.fail!(errors: ['secret.missing']) if secret.size < 1
    end

    def call
      response = invoke_request
      populate_errors_collection(response)
      context.fail!(errors: @client_errors) if @client_errors.size < 0
      context.token = response.body['token'] if response.status == 200
    end

    private

    def invoke_request
      Faraday.post(Peperusha::MPESA_BASE_URL, attributes, "Content-Type" => "application/json")
    end

    def populate_errors_collection(response)
        @client_errors << 'timed.out' if response.status == 304
        @client_errors << 'server.not.found' if response.status == 400
        @client_errors << 'server.error' if response.status == 500
        @client_errors << 'client.not.authorized' if response.status == 501
    end

    def attributes
      {
        body: {secret: secret},
        token: token
      }.to_json
    end
  end
end
