# Keeps track of a query's connection, since this gem is intended to be used
# with multiple accounts/connections (unlike activerecord which usually only
# has a single connection to worry about.
module Geotab
  module Concerns
    module Connectable
      # Returns either the connection object with with the .with_connection
      # method, or the connection configuration.
      def connection
        if @connection
          @connection
        elsif Geotab.connection_block
          Geotab.connection_block
        elsif Geotab.has_config?
          OpenStruct.new({
            credentials:
              "{'database':'#{Geotab.database}','userName':'#{Geotab.username}','password':'#{Geotab.password}'}",
            path: Geotab.path
          })
        end
      end

      # Meant to be added to a query to specify the connection to use to query
      # the API. Ex: Geotab::Device.with_connection(con).first
      def with_connection(connection)
        @connection = connection

        self
      end

      # Reset connection. This should be done after each .all call to avoid
      # stale connection.
      def clear_connection
        @connection = nil
      end
    end
  end
end
