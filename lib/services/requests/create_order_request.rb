module Services
  module Requests
    class CreateOrderRequest

      attr_reader :current_user_id, :items

      def initialize(current_user_id:, items:)
        self.current_user_id = current_user_id
        self.items = items
      end

      private

      attr_writer :current_user_id, :items

    end
  end
end
