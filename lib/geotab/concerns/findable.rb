module Geotab
  module Concerns
    module Findable
      module ClassMethods

        def geotab_reference_name
          self.to_s.split("::").last.gsub("Datum", "Data")
        end

        def all(parent, params={})
          search = params.to_s.gsub(" ", "").gsub("=>", ":").gsub("\"", "'")

          response = Faraday.get("https://#{parent.path}/apiv1/Get",
                                 {typeName: geotab_reference_name,
                                  credentials: parent.credentials,
                                  search: search})
          
          attributes = JSON.parse(response.body).to_ostruct_recursive.result

          results = []

          if attributes && attributes.any?
            attributes.each do |result|
              results.push(new(result, parent))
            end
          end

          results
        end

        def find(parent, id)
          where(parent, {'id' => "#{id}"}).first
        end

        alias_method :where, :all
      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end