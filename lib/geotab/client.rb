module Geotab
  class Client
    AUTHENTICATION_URL = "https://my.geotab.com/apiv1/Authenticate"

    def authenticate(username, password, database=nil)
      response = Faraday.get(AUTHENTICATION_URL,
                             {userName: username, password: password, database: database})
      attributes = JSON.parse(response.body)

      @path = attributes["result"]["path"]
      set_credentials(attributes["result"]["credentials"].merge("path" => @path))
    end

    def set_credentials(credentials)
      @credentials = credentials
      @path = credentials["path"]
      @credentials
    end

    def devices
      response = Faraday.get("https://#{@path}/apiv1/Get",
                             {typeName: "Device", credentials: credentials})
      attributes = JSON.parse(response.body)

      devices = []
      attributes.to_ostruct_recursive.result.each do |device|
        devices.push(Device.new(device, self))
      end

      devices
    end

    def last_odometer_reading(device_id, from_date = Date.today - 1, to_date = Date.today)
      response = Faraday.get("https://#{@path}/apiv1/Get",
                             {typeName: "StatusData",
                              credentials: credentials,
                              search: "{'deviceSearch':{'id':'#{device_id}'},'diagnosticSearch':{'id':'DiagnosticOdometerAdjustmentId'},'fromDate':'#{(from_date).to_s}'}"})
      attributes = JSON.parse(response.body)
      readings = attributes.to_ostruct_recursive.result

      reading = readings.last(2).first # the last one is usually junk

      mi = (reading.data / 1609.344).to_i
      km = (reading.data / 1000).to_i

      {mi: mi, km: km, date: reading.dateTime}
    end

    def location(device_id)
      response = Faraday.get("https://#{@path}/apiv1/Get",
                             {typeName: "DeviceStatusInfo",
                              credentials: credentials,
                              search: "{'deviceSearch':{'id':'#{device_id}'}}"})
      attributes = JSON.parse(response.body)
      result = attributes.to_ostruct_recursive.result
      result.first
    end

    def credentials
      "{'database':'#{@credentials['database']}','userName':'#{@credentials['userName']}','sessionId':'#{@credentials['sessionId']}'}"
    end

    def path
      @path
    end
  end
end