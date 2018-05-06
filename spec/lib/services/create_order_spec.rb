describe Services::CreateOrder do

  context 'when no items are selected' do
    it 'returns an error response with Services::Errors::CreateOrder::ItemsNotSelectedError error' do
      request = Services::Requests::CreateOrderRequest.new(current_user_id: rand(10), items: nil)
      service = Services::CreateOrder.new(request)
      response = service.execute!

      expect(response.success?).to be false
      expect(response.error).to be_instance_of(
        Services::Errors::CreateOrder::ItemsNotSelectedError
      )
    end
  end

  context 'when atleast one item is selected' do
    let(:items_repo) { double('ItemsRepository') }

    context 'when atleast one selected item is not available' do
      let(:item) do
        Entities::Item.new do |item|
          item.id = item.id = rand(10)
          item.available_count = 1
        end
      end

      let(:request_items) do
        [
          Services::Requests::Item.new(id: item.id, required_count: 2)
        ]
      end

      let(:create_order_unit_of_work) { double('Persistence::UnitsOfWork::CreateOrder') }

      before do
        items_collection = { item.id => item }

        allow(Persistence::UnitsOfWork::CreateOrder).to(
          receive(:new).and_return(create_order_unit_of_work)
        )

        allow(create_order_unit_of_work).to receive(:items).and_return(items_collection)
      end

      it 'returns an error response with Services::Errors::CreateOrder::ItemsNotAvailableError error' do
        request = Services::Requests::CreateOrderRequest.new(
          current_user_id: rand(10), items: request_items
        )
        service = Services::CreateOrder.new(request)
        response = service.execute!

        expect(response.success?).to be false
        expect(response.error).to be_instance_of(
          Services::Errors::CreateOrder::ItemsNotAvailableError
        )
        expect(response.error.unavailable_items).to eq(request_items)
      end
    end

    context 'when all selected items are available' do
      let(:item_available_count) { 2 }
      let(:item) do
        Entities::Item.new do |item|
          item.id = item.id = rand(10)
          item.name = "Item1"
          item.price = rand(1000)
          item.available_count = item_available_count
        end
      end
      let(:items_collection) { { item.id => item } }

      let(:user) do
        Entities::User.new do |user|
          user.id = rand(10)
        end
      end

      let(:item_ordered_count) { 1 }
      let(:request_items) do
        [
          Services::Requests::Item.new(id: item.id, required_count: item_ordered_count)
        ]
      end

      let(:users_repo) { double("UsersRepository") }
      let(:create_order_unit_of_work) { double('Persistence::UnitsOfWork::CreateOrder') }

      before do
        build_user_repository
        build_unit_of_work
      end

      it 'creates the order successfully' do
        request = Services::Requests::CreateOrderRequest.new(
          current_user_id: user.id, items: request_items
        )
        service = Services::CreateOrder.new(request)

        expect_service_to_send_order_to_unit_of_work
        response = service.execute!
        expect_response_to_be_success(response)
      end

      def build_user_repository
        allow(Persistence::Repository).to(
          receive(:for)
            .with(Entities::User)
            .and_return(users_repo)
        )

        allow(users_repo).to receive(:find).with(user.id).and_return(user)
      end

      def build_unit_of_work
        allow(Persistence::UnitsOfWork::CreateOrder).to(
          receive(:new).and_return(create_order_unit_of_work)
        )

        allow(create_order_unit_of_work).to receive(:items).and_return(items_collection)
      end

      def expect_service_to_send_order_to_unit_of_work
        expect(create_order_unit_of_work).to(
          receive(:new_order).with(instance_of(Entities::Order)).once
        )
        expect(create_order_unit_of_work).to(
          receive(:new_ordered_items).with(array_including(instance_of(Entities::OrderedItem))).once
        )
        expect(create_order_unit_of_work).to(
          receive(:updated_items).with(array_including(instance_of(Entities::Item))).once
        )
        expect(create_order_unit_of_work).to receive(:save!).once
      end

      def expect_response_to_be_success(response)
        expect(response.success?).to be true
        expect(response.order).to be_instance_of(Entities::Order)

        expect(response.order.user_id).to be(user.id)
        expect(response.order.ordered_items.map(&:item)).to include(item)
        expect(item.available_count).to eq(item_available_count - item_ordered_count)
      end
    end
  end

end
