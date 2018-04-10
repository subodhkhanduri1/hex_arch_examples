describe Services::Responses::Base do

  context '#initialize' do
    it 'creates a response object with the common attributes' do
      error = double('TestError')
      response = described_class.new(error: error)

      expect(response.error).to eq(error)
    end
  end

  context '#success?' do
    context 'when an error object is given' do
      it 'is false' do
        error = double('TestError')
        response = described_class.new(error: error)


        expect(response.success?).to be false
      end
    end

    context 'when an error object not is given' do
      it 'is true' do
        response = described_class.new

        expect(response.success?).to be true
      end
    end
  end

end
