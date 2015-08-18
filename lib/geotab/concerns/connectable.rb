# Keeps track of a query's connection, since this gem is intended to be used
# with multiple accounts/connections (unlike activerecord which usually only
# has a single connection to worry about.
module Geotab
  module Concerns
    module Connectable
      def connection
        @connection
      end

      # Meant to be added to a query to specify the connection to use to query
      # the API. Ex: Geotab::Device.with_connection(con).first
      def with_connection(connection)
        @connection = connection

        self
      end
    end
  end
end