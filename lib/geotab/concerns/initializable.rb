module Geotab
  module Concerns
    module Initializable
      attr :data, true
      attr :parent, true

      def initialize(data, parent)
        self.data = data
        self.parent = parent
      end
    end
  end
end