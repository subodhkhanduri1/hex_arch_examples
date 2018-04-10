module Services
  module Errors
    module CreateOrder
      class ItemsNotAvailableError < StandardError

        attr_reader :unavailable_items

        def initialize(unavailable_items)
          self.unavailable_items = unavailable_items

          super
        end

        private

        attr_writer :unavailable_items
      end
    end
  end
end
