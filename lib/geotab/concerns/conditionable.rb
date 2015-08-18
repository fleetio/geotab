# Keep track of the conditions for a query. This is needed due to where clauses
# being chainable.
module Geotab
  module Concerns
    module Conditionable
      def conditions
        @conditions ||= {}
      end

      # Conditions should be cleared after each .all class so that new
      # queries do not use previous queries' where clauses.s
      def clear_conditions
        @conditions = {}
      end

      # Format the conditions hash according to Geotab spec. A normal hash
      # looks like: {'id':'XXXX'}
      def formatted_conditions
        conditions.to_s.gsub(/\s*=>\s*/, ":").gsub("\"", "'")
      end
    end
  end
end