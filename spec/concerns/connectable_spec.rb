require "spec_helper"

describe Geotab::Concerns::Connectable do
  let(:dummy) { Class.new { extend Geotab::Concerns::Connectable } }
  let(:connection) { "connection placeholder" }

  before :each do
    Thread.current[:geotab_connection] = connection
  end

  describe ".connection" do
    it "should be a simple getter" do
      expect(dummy.connection).to eq(connection)
    end
  end

  describe ".with_connection" do
    it "should set the connection" do
      expect{ dummy.with_connection("conn") }.to change{ dummy.connection }.to("conn")
    end

    it "should be chainable" do
      expect(dummy.with_connection("conn")).to eq dummy
    end
  end
end
