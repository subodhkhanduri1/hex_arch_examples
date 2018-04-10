describe Services::Requests::CreateOrderRequest do

  context '#initialize' do
    let(:items) do
      [
        Services::Requests::Item.new(id: rand(10), required_count: 1)
      ]
    end

    let(:user_id) { rand(10) }

    subject { described_class.new(current_user_id: user_id, items: items) }

    it 'creates the request object with the given attributes' do
      expect(subject.current_user_id).to eq(user_id)
      expect(subject.items).to eq(items)
    end
  end

end
