module Entities
  class OrderedItem

    attr_accessor :id, :order_id, :item_id, :count, :item

    def initialize
      config = ::OpenStruct.new
      yield config if block_given?

      config.each_pair do |attribute, value|
        next unless self.respond_to?(attribute.to_s + '=')

        # This is allowed since we are calling send on the object from within itself.
        # Encapsulation is not violated.
        self.send(attribute.to_s + '=', value)
      end
    end

  end
end
