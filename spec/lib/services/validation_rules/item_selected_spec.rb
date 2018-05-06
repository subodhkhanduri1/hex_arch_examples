module Services
  module ValidationRules
    describe ItemSelected do

      context '#initialize' do
        it 'creates a new validator with the given request' do
          request = double("Request")

          validator = described_class.new(request, nil)
          expect(validator).to be_instance_of(described_class)
        end
      end

      context '#validate' do
        context 'when items are selected' do
          it 'returns nil' do
            request_items = [
              Services::Requests::Item.new(id: rand(10), required_count: 2)
            ]

            request = Services::Requests::CreateOrderRequest.new(
              current_user_id: rand(10), items: request_items
            )

            validation_rule = described_class.new(request, nil)

            expect(validation_rule.validate).to be(nil)
          end
        end

        context 'when items are not selected' do
          context 'and items are nil' do
            it 'returns ItemsNotSelectedError' do
              request = Services::Requests::CreateOrderRequest.new(
                current_user_id: rand(10), items: nil
              )

              validation_rule = described_class.new(request, nil)

              error = validation_rule.validate
              expect(error).to be_instance_of(Errors::CreateOrder::ItemsNotSelectedError)
            end
          end

          context 'and items are empty' do
            it 'returns ItemsNotSelectedError' do
              request = Services::Requests::CreateOrderRequest.new(
                current_user_id: rand(10), items: []
              )

              validation_rule = described_class.new(request, nil)

              error = validation_rule.validate
              expect(error).to be_instance_of(Errors::CreateOrder::ItemsNotSelectedError)
            end
          end
        end
      end
    end
  end
end
