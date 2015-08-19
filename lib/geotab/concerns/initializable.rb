module Geotab
  module Concerns
    module Initializable
      attr :data, true
      attr :parent, true

      def initialize(data, parent=nil)
        self.data = data
        self.parent = parent
      end
    end
  end
end