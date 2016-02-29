# Add support for simple query methods such as where, find, all, and first.
# Where clauses are chainable and are simply appended to the search param.
# Ex:
#   Geotab::Device.with_connection(conn).
#     where({"serialNumber" => "G7B020D3E1A4"}).
#     where({"name" => "07 BMW 335i"}).
#     all
module Geotab
  module Concerns
    module Findable
      module ClassMethods
        include Geotab::Concerns::Conditionable
        include Geotab::Concerns::Connectable

        # Format of conditions should match that of geotab's sdk, as the
        # conditions are passed pretty much as is to the API.
        def where(params={})
          conditions.merge!(params)

          self
        end

        # If the id of the resource is known, query it using a simple where
        # clause. Note that most geotab resources do not allow other conditions
        # if the id is specified.
        def find(id)
          where({'id' => "#{id}"}).first
        end

        # Each query should include this method at the end to perform the
        # actual call to the API.
        def all
          response = RestClient::Request.execute({
            url: "https://#{connection.path}/apiv1/Get",
            method: :get,
            verify_ssl: false,
            headers: { params: { typeName: "Device", credentials: connection.credentials, search: formatted_conditions }}
          })

          body = JSON.parse(response.body).to_ostruct_recursive

          if JSON.parse(response.body).has_key?("error")
            if body.error.errors.first.message.start_with?("Incorrect MyGeotab login credentials")
              raise IncorrectCredentialsError, body.error.errors.first.message
            else
              raise ApiError, body.error.errors.first.message
            end
          else
            attributes = body.result
            results = []

            if attributes && attributes.any?
              attributes.each do |result|
                results.push(new(result, connection))
              end
            end

            reset

            results
          end
        end

        def first
          all[0]
        end

        # Class names should match geotab reference names pretty close,
        # except where it doesn't make sense (like Data/Datum). This value is
        # passed to geotab as the typeName param.
        def geotab_reference_name
          self.to_s.split("::").last.gsub("Datum", "Data")
        end

        # Should run this after each query to avoid stale data
        def reset
          # Conditions are now stale, so clear them
          clear_conditions

          # Connection is also stale
          clear_connection
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end
