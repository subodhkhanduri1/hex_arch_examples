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
      if request.items.nil? || request.items.empty?
        return Errors::CreateOrder::ItemsNotSelectedError.new
      end
    end

    def check_items_available
      unavailable_items = []

      request.items.each do |item|
        if items[item.id].available_count < item.required_count
          unavailable_items << item
        end
      end

      return if unavailable_items.empty?

      return Errors::CreateOrder::ItemsNotAvailableError.new(unavailable_items)
    end

    def items
      @items ||= items_repository.find_all(item_ids)
    end

    def item_ids
      @item_ids ||= request.items.map(&:id)
    end

    def items_repository
      @items_repository ||= Persistence::Repository.for(Entities::Item)
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
