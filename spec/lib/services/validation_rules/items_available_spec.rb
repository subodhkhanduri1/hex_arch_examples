module Services
  module ValidationRules
    describe ItemsAvailable do

      context '#validate' do
        context 'when all selected items are available' do
          it 'returns nil' do
            request_item = Services::Requests::Item.new(id: rand(10), required_count: 2)

            request = Services::Requests::CreateOrderRequest.new(
              current_user_id: rand(10), items: [request_item]
            )

            item = Entities::Item.new do |item|
              item.id = request_item.id
              item.available_count = 2
            end

            unit_of_work = double("CreateOrderUnitOfWork")
            allow(unit_of_work).to receive(:items).and_return({ item.id => item })

            validation_rule = described_class.new(request, unit_of_work)

            expect(validation_rule.validate).to be(nil)
          end
        end

        context 'when atleast 1 item is not available' do
          it 'returns ItemsNotAvailableError' do
            request_item = Services::Requests::Item.new(id: rand(10), required_count: 2)

            request = Services::Requests::CreateOrderRequest.new(
              current_user_id: rand(10), items: [request_item]
            )

            item = Entities::Item.new do |item|
              item.id = request_item.id
              item.available_count = 1
            end

            unit_of_work = double("CreateOrderUnitOfWork")
            allow(unit_of_work).to receive(:items).and_return({ item.id => item })

            validation_rule = described_class.new(request, unit_of_work)

            expect(validation_rule.validate).to be_instance_of(Errors::CreateOrder::ItemsNotAvailableError)
          end
        end
      end
    end
  end
end
