describe Entities::Order do

  [:id, :user_id, :ordered_items, :total_price].each do |attr|
    it "has attribute '#{attr}'" do
      expect(subject).to have_attribute(attr)
    end
  end

end
