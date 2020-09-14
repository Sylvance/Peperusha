RSpec.describe Peperusha::Authenticate do
  subject{ described_class.call(consumer_key: consumer_key, consumer_secret: consumer_secret) }

  let(:consumer_key) { 'AUcdE5WbZDHfSii7AmBUSnUpgxct0xyz' }
  let(:consumer_secret) { '3ebBXm63tiNrd51b' }
  let(:response) { Struct.new(:status, :body) }
  let(:access_token) { '0IYAwuRlvqilUUvoq1cfAAUKJ2IY' }
  let(:expires_in) { '3599' }

  context 'with response having success status code' do
    before do
      allow(Peperusha::Client).to receive(:invoke_token_request).with(consumer_key, consumer_secret).and_return(success_response)
    end

    let(:success_response) { response.new(success_status_code, success_response_body) }
    let(:success_response_body) { { access_token: access_token, expires_in: expires_in }.to_json }
    let(:success_status_code) { 200 }

    it 'is successful' do
      expect(subject.success?).to be_truthy
    end

    it 'returns a token' do
      expect(subject.token).not_to be nil
      expect(subject.token).to eq(access_token)
    end

    it 'returns an expires_in' do
      expect(subject.expires_in).not_to be nil
      expect(subject.expires_in).to eq(expires_in)
    end
  end

  context 'with response having error status code' do
    before do
      allow(Peperusha::Client).to receive(:invoke_token_request).with(consumer_key, consumer_secret).and_return(errored_response)
    end

    context 'errors' do
      let(:errored_response) { response.new(error_status_code, errored_response_body) }
      let(:errored_response_body) { { error: '' }.to_json }
      let(:error_status_code) { '' }

      it 'is a failure' do
        expect(subject.success?).to be_falsy
      end

      it 'returns an errors array' do
        expect(subject.errors).not_to be nil
        expect(subject.errors).to eq(['response.failure'])
      end
  
      context 'when status code is bad request' do
        let(:error_status_code) { 400 }

        it 'returns an errors array' do
          expect(subject.errors).to eq(['client.bad.request', 'response.failure'])
        end
      end

      context 'when status code is unauthorized' do
        let(:error_status_code) { 401 }

        it 'returns an errors array' do
          expect(subject.errors).to eq(['client.not.authorized', 'response.failure'])
        end
      end

      context 'when status code is forbidden' do
        let(:error_status_code) { 403 }

        it 'returns an errors array' do
          expect(subject.errors).to eq(['client.is.forbidden', 'response.failure'])
        end
      end

      context 'when status code is not found' do
        let(:error_status_code) { 404 }

        it 'returns an errors array' do
          expect(subject.errors).to eq(['server.not.found', 'response.failure'])
        end
      end

      context 'when status code is server timeout' do
        let(:error_status_code) { 408 }

        it 'returns an errors array' do
          expect(subject.errors).to eq(['server.timeout', 'response.failure'])
        end
      end

      context 'when status code is server internal error' do
        let(:error_status_code) { 500 }

        it 'returns an errors array' do
          expect(subject.errors).to eq(['server.internal.error', 'response.failure'])
        end
      end
    end
  end

  context 'with missing Mpesa consumer key & consumer secret' do
    let(:consumer_key) { nil }
    let(:consumer_secret) { nil }

    it 'is a failure' do
      expect(subject.success?).to be_falsy
    end

    it 'returns an errors array' do
      expect(subject.errors).to eq(['consumer_key.missing', 'consumer_secret.missing'])
    end
  end
end
