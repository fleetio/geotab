module Geotab
  class Device
    include Geotab::Concerns::Findable
    include Geotab::Concerns::Initializable

    def status_data
      Geotab::StatusDatum.where(parent, {'deviceSearch' => {'id' => data.id}})
    end

    def odometer_readings
      Geotab::StatusDatum.where(parent, {
        'deviceSearch' => {'id' => data.id},
        'diagnosticSearch' => {'id' => 'DiagnosticOdometerAdjustmentId'}
      })
    end

    def device_status_infos
      Geotab::DeviceStatusInfo.where(parent, {'deviceSearch' => {'id' => data.id}})
    end

    def fault_data
      Geotab::FaultDatum.where(parent, {'deviceSearch' => {'id' => data.id}})
    end

    def location
      result = device_status_infos.first

      {
        date: result.data.dateTime,
        bearing: result.data.bearing,
        current_state_duration: result.data.currentStateDuration,
        is_device_communicating: result.data.isDeviceCommunicating,
        is_driving: result.data.isDriving,
        latitude: result.data.latitude,
        longitude: result.data.longitude,
        speed: result.data.speed
      }
    end
  end
end