require "spec_helper"

describe Geotab::Device do
  let(:client) { Geotab::Client.new }

  before :each do
    VCR.use_cassette "client/authenticate" do
      client.authenticate("username", "password", "database", nil)
    end
  end

  describe ".all" do
    it "should return an array of devices" do
      VCR.use_cassette "device/all" do
        devices = Geotab::Device.with_connection(client).all
        expect(devices.all?{ |d| d.is_a?(Geotab::Device)}).to be(true)
      end
    end
  end

  describe ".first" do
    it "should return a single device" do
      VCR.use_cassette "device/all" do
        device = Geotab::Device.with_connection(client).first
        expect(device.is_a?(Geotab::Device)).to be(true)
      end
    end
  end

  describe ".find" do
    it "should return a single device" do
      VCR.use_cassette "device/find" do
        device = Geotab::Device.with_connection(client).find("b1")
        expect(device.is_a?(Geotab::Device)).to be(true)
      end
    end
  end

  describe "associations" do
    let(:device) { Geotab::Device.with_connection(client).first }
    it "returns StatusData objects" do
      VCR.use_cassette "device/status_data" do
        data = device.status_data.where({"fromDate" => (DateTime.now - 1).to_s}).all
        expect(data.count > 0 && data.all?{ |d| d.is_a?(Geotab::StatusDatum) }).to be(true)
      end
    end

    it "returns DeviceStatusInfo objects" do
      VCR.use_cassette "device/device_status_infos" do
        data = device.device_status_infos.where({"fromDate" => (DateTime.now - 1).to_s}).all

        expect(data.count > 0 && data.all?{ |d| d.is_a?(Geotab::DeviceStatusInfo) }).to be(true)
      end
    end

    it "returns FaultData objects" do
      VCR.use_cassette "device/fault_data" do
        data = device.fault_data.where({"fromDate" => (DateTime.now - 100).to_s}).all
        expect(data.count > 0 && data.all?{ |d| d.is_a?(Geotab::FaultDatum) }).to be(true)
      end
    end
  end

  describe ".location" do
    let(:device) { Geotab::Device.with_connection(client).first }

    it "should return a valid latitude" do
      VCR.use_cassette "device/location" do
        expect(device.location[:latitude]).to be_between(-90, 90).inclusive
      end
    end

    it "should return a valid longitude" do
      VCR.use_cassette "device/location" do
        expect(device.location[:longitude]).to be_between(-180, 180).inclusive
      end
    end
  end
end
