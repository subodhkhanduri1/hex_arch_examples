describe Entities::OrderedItem do

  [:id, :order_id, :item_id, :count, :item].each do |attr|
    it "has attribute '#{attr}'" do
      expect(subject).to have_attribute(attr)
    end
  end

end
