require "spec_helper"

describe Geotab::Concerns::Findable do
  let(:dummy) { Class.new { include Geotab::Concerns::Findable } }
  let(:conditions_1) { {"c1" => "v1"} }
  let(:conditions_2) { {"c2" => "v3"} }

  # before :each do
  #   allow(dummy).to receive(:connection) { 
  #     OpenStruct.new({
  #       path: "my100.geotab.com"
  #     })
  #   }

  #   allow(Faraday).to receive(:get) {
  #     OpenStruct.new({
  #       body: "{}"
  #     }) 
  #   }
  # end

  describe ".where" do
    it "should append conditions" do
      expect{ dummy.where(conditions_1) }.to change{ dummy.conditions }.to(conditions_1)
    end

    it "should be chainable" do
      expect{ dummy.where(conditions_1).where(conditions_2) }.
        to change{ dummy.conditions }.to(conditions_1.merge(conditions_2))
    end
  end

  describe ".find" do
    before :each do
      allow(dummy).to receive(:all) { [] }
    end

    it "should return the first element where the id matches" do
      expect(dummy).to receive(:where).with({'id' => "b1"}) { [] }

      dummy.find("b1")
    end
  end

  describe ".first" do
    before :each do
      allow(dummy).to receive(:all) { [] }
    end

    it "should return the first element in the .all result" do
      expect(dummy).to receive(:all)

      dummy.first
    end
  end

  describe ".geotab_reference_name" do
    context "class name without namespace" do
      before(:each) { allow(dummy).to receive(:to_s) { "C" } }

      it "should return the class name" do
        expect(dummy.geotab_reference_name).to eq "C"
      end
    end

    context "class name with namespace" do
      it "should return the class name" do
        allow(dummy).to receive(:to_s) { "A::B::C" }
        expect(dummy.geotab_reference_name).to eq "C"
      end
    end

    context "Data/Datum" do
      it "should return the class name" do
        allow(dummy).to receive(:to_s) { "Datum" }
        expect(dummy.geotab_reference_name).to eq "Data"
      end
    end
  end
end
