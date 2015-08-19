require "spec_helper"

describe Geotab::Concerns::Initializable do
  let(:dummy) { Class.new { include Geotab::Concerns::Initializable } }

  describe ".initialize" do
    it "should set the data" do
      expect(dummy.new("data", "parent").data).to eq("data")
    end

    it "should set the parent" do
      expect(dummy.new("data", "parent").parent).to eq("parent")
    end
  end
end
