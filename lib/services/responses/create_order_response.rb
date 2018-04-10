module Services
  module Responses
    class CreateOrderResponse < Base

      attr_reader :order

      def initialize(error: nil, order: nil)
        self.order = order

        super(error: error)
      end

      protected

      attr_writer :order

    end
  end
end
