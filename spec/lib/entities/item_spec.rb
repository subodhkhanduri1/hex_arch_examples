describe Entities::Item do

  [:id, :name, :price, :available_count].each do |attr|
    it "has attribute '#{attr}'" do
      expect(subject).to have_attribute(attr)
    end
  end

end
