module Geotab
  class Device
    include Geotab::Concerns::Findable
    include Geotab::Concerns::Initializable

    def status_data
      Geotab::StatusDatum.with_connection(parent).where({'deviceSearch' => {'id' => data.id}})
    end

    def odometer_readings
      Geotab::StatusDatum.with_connection(parent).where({
        'deviceSearch' => {'id' => data.id},
        'diagnosticSearch' => {'id' => 'DiagnosticOdometerAdjustmentId'}
      })
    end

    def secondary_odometer_readings
      Geotab::StatusDatum.with_connection(parent).where({
        'deviceSearch' => {'id' => data.id},
        'diagnosticSearch' => {'id' => 'DiagnosticEngineHoursAdjustmentId'}
      })
    end

    def pto_hours
      Geotab::StatusDatum.with_connection(parent).where({
        'deviceSearch' => {'id' => data.id},
        'diagnosticSearch' => {'id' => 'DiagnosticPtoEnabledId'}
      })
    end

    def device_status_infos
      Geotab::DeviceStatusInfo.with_connection(parent).where({'deviceSearch' => {'id' => data.id}})
    end

    def fault_data
      Geotab::FaultDatum.with_connection(parent).where({'deviceSearch' => {'id' => data.id}})
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
