describe Services::Responses::CreateOrderResponse do

  context '#initialize' do

    context 'when error is given' do
      let(:error) { StandardError.new }

      subject { described_class.new(error: error) }

      it 'creates the response object with the error' do
        expect(subject.error).to be(error)
      end
    end

    context 'when order is given' do
      let(:order) do
        Entities::Order.new do |order|
          order.id = rand(10)
          order.user_id = rand(10)
        end
      end

      subject { described_class.new(order: order) }

      it 'creates the response object with the order' do
        expect(subject.order).to be(order)
      end
    end
  end

end
