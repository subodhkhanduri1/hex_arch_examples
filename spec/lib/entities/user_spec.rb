describe Entities::User do

  [:id].each do |attr|
    it "has attribute '#{attr}'" do
      expect(subject).to have_attribute(attr)
    end
  end

end
