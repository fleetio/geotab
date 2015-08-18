module Geotab
  module Concerns
    module Findable
      module ClassMethods
        include Geotab::Concerns::Connectable

        def conditions
          @conditions ||= {}
        end

        def connection
          @connection
        end

        def with_connection(connection)
          @connection = connection

          self
        end

        def clear_conditions
          @conditions = {}
        end

        def where(params={})
          conditions.merge!(params)

          self
        end

        def find(id)
          where({'id' => "#{id}"}).first
        end

        def all
          search = conditions.to_s.gsub(/\s*=>\s*/, ":").gsub("\"", "'")
          response = Faraday.get("https://#{connection.path}/apiv1/Get",
                                 {typeName: geotab_reference_name,
                                  credentials: connection.credentials,
                                  search: search})
          
          attributes = JSON.parse(response.body).to_ostruct_recursive.result

          results = []

          if attributes && attributes.any?
            attributes.each do |result|
              results.push(new(result, connection))
            end
          end

          clear_conditions
          results
        end

        def first
          all.first
        end

        def geotab_reference_name
          self.to_s.split("::").last.gsub("Datum", "Data")
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end