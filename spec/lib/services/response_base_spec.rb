describe Services::ResponseBase do

  context '#initialize' do
    it 'creates a response object with the common attributes' do
      error = double('TestError')
      response = described_class.new(error: error)

      expect(response).to be_instance_of(described_class)
      expect(response.error).to eq(error)
    end
  end

end
