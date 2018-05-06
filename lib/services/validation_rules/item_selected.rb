module Services
  module ValidationRules
    class ItemSelected

      def initialize(request, unit_of_work)
        self.request = request
        self.unit_of_work = unit_of_work
      end

      def validate
        if request.items.nil? || request.items.empty?
          return Errors::CreateOrder::ItemsNotSelectedError.new
        end
      end

      private

      attr_accessor :request, :unit_of_work
    end
  end
end
