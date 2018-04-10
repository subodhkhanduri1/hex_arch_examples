describe Services::Errors::CreateOrder::ItemsNotAvailableError do

  context '#initialize' do
    let(:unavailable_item) do
      Services::Requests::Item.new(id: rand(10), required_count: 1)
    end

    subject { described_class.new([unavailable_item]) }

    it 'creates the error object with the given unavailable items' do
      expect(subject.unavailable_items).to include(unavailable_item)
    end
  end
end
