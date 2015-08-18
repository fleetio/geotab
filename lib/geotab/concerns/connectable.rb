module Geotab
  module Concerns
    module Connectable
      module ClassMethods

        def conditions
          @conditions ||= {}
        end

        def clear_conditions
          @conditions = {}
        end

      end

      def self.included(base)
        base.extend(ClassMethods)
      end

    end
  end
end