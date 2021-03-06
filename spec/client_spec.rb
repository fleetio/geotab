require "spec_helper"

describe Geotab::Client do
  let(:client) { Geotab::Client.new }

  describe ".authenticate" do
    before :each do
      VCR.use_cassette "client/authenticate" do
        client.authenticate("username", "password", "database", nil)
      end
    end

    it "should set the path" do
      expect(client.path).to eq "my30.geotab.com"
    end

    it "should set the credentials" do
      expect(client.credentials).
        to eq({ database: "database", userName: "username", sessionId: "sessionId" })
    end
  end
end
