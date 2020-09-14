RSpec.describe Peperusha::Authentication do
  subject{ described_class.call(consumer_key: consumer_key, consumer_secret: consumer_secret) }

  let(:consumer_key) { 'AUcdE5WbZDHfSii7AmBUSnUpgxct0xyz'}
  let(:consumer_secret) { '3ebBXm63tiNrd51b'}

  context 'with the correct parameters' do
    before do
    allow()
    end

    it "is successful" do
      expect(subject).to be_successful
    end

    it "returns a token" do
      expect(subject.token).not_to be nil
    end

    it "returns an expires_in" do
      expect(subject.token).not_to be nil
    end
  end
end
