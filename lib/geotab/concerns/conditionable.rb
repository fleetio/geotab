# Keep track of the conditions for a query. This is needed due to where clauses
# being chainable.
module Geotab
  module Concerns
    module Conditionable
      def conditions
        Thread.current[:geotab_conditions] ||= {}
      end

      # Conditions should be cleared after each .all class so that new
      # queries do not use previous queries' where clauses.s
      def clear_conditions
        Thread.current[:geotab_conditions] = {}
      end
    end
  end
end
