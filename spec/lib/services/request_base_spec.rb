describe Services::RequestBase do

  context '#initialize' do
    it 'creates a request object with the common attributes' do
      current_user_id = rand(10)
      request = described_class.new(current_user_id: current_user_id)

      expect(request).to be_instance_of(described_class)
      expect(request.current_user_id).to eq(current_user_id)
    end
  end

end
