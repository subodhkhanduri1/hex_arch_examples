module Services
  module ValidationRules
    class ItemsAvailable

      def initialize(request, unit_of_work)
        self.request = request
        self.unit_of_work = unit_of_work
      end

      def validate
        return if unavailable_items.empty?

        return Errors::CreateOrder::ItemsNotAvailableError.new(unavailable_items)
      end

      private

      attr_accessor :request, :unit_of_work

      def unavailable_items
        @unavailable_items ||= (unavailable_items = []

        request.items.each do |item|
          if unit_of_work.items[item.id].available_count < item.required_count
            unavailable_items << item
          end
        end

        unavailable_items)
      end
    end
  end
end
