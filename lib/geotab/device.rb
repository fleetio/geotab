module Geotab
  class Device
    attr :data, true
    attr :parent, true

    def initialize(data, parent)
      self.data = data
      self.parent = parent
    end

    def odometer_readings(from_date = Date.today - 1, to_date = Date.today)
      response = Faraday.get("https://#{parent.path}/apiv1/Get",
                             {typeName: "StatusData",
                              credentials: parent.credentials,
                              search: "{'deviceSearch':{'id':'#{data.id}'},'diagnosticSearch':{'id':'DiagnosticOdometerAdjustmentId'},'fromDate':'#{(from_date).to_s}'}"})
      attributes = JSON.parse(response.body)
      readings = attributes.to_ostruct_recursive.result
    end

    def latest_odometer_reading
      mi = (odometer_readings.last.data / 1609.344).to_i
      km = (odometer_readings.last.data / 1000).to_i

      {mi: mi, km: km}
    end
  end
end