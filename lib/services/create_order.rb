module Services
  class CreateOrder < Base

    include SessionableService

    def execute!
      error = validate_request

      return Responses::CreateOrderResponse.new(error: error) if error

      Responses::CreateOrderResponse.new(order: create_order)
    end

    private

    attr_accessor :request, :order

    def validate_request
      error = check_items_selected
      return error if error

      check_items_available
    end

    def check_items_selected
      ValidationRules::ItemSelected.new(request, unit_of_work).validate
    end

    def check_items_available
      ValidationRules::ItemsAvailable.new(request, unit_of_work).validate
    end

    def items
      @items ||= unit_of_work.items
    end

    def create_order
      order = Entities::Order.new do |order|
        order.user_id = current_user.id
        order.ordered_items = ordered_items
        order.total_price = items_total_price
      end

      unit_of_work.new_order(order)
      unit_of_work.new_ordered_items(ordered_items)
      unit_of_work.updated_items(items.values)
      unit_of_work.save!

      order
    end

    def ordered_items
      @ordered_items ||= request.items.map do |request_item|
        item = items[request_item.id]

        item.available_count -= request_item.required_count

        Entities::OrderedItem.new do |ordered_item|
          ordered_item.item_id = item.id
          ordered_item.count = request_item.required_count
          ordered_item.item = item
        end
      end
    end

    def items_total_price
      total = 0

      request.items.each do |item|
        total += (items[item.id].price * item.required_count)
      end

      total
    end

    def unit_of_work
      @unit_of_work ||= Persistence::UnitsOfWork::CreateOrder.new
    end

  end
end
