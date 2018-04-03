describe Services::Base do

  let(:test_request) { double('Request') }

  context '#initialize' do
    it 'creates a new Service object' do
      expect(described_class.new(test_request)).to be_instance_of(described_class)
    end
  end

  context '#execute!' do
    it 'raises NotImplementedError' do
      service = described_class.new(test_request)
      expect { service.execute! }.to raise_error(NotImplementedError)
    end
  end

end
