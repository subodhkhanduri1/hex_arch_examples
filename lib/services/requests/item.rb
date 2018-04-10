module Services
  module Requests

    class Item

      attr_reader :id, :required_count

      def initialize(id:, required_count:)
        self.id = id
        self.required_count = required_count
      end

      private

      attr_writer :id, :required_count

    end

  end
end
