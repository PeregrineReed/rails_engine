require 'rails_helper'

RSpec.describe Item, type: :model do

  describe 'Relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  describe 'Class Methods' do

    it '::highest_revenue(limit)' do
      items = create_list(:item, 5)
      counter = 1
      items.each do |item|
        invoice = create(:invoice)
        create(:transaction, invoice: invoice, result: 'success')
        counter.times do
          create(:invoice_item, item: item, invoice: invoice, unit_price: 1000 * counter, quantity: 10 * counter)
        end
        counter += 1
      end
      invoice = create(:invoice)
      create(:transaction, invoice: invoice, result: 'success')
      create(:invoice_item, item: items[2], invoice: invoice, unit_price: 5000 * counter, quantity: 25 * counter)

      three_items = Item.highest_revenue(3)
      two_items = Item.highest_revenue(2)
      one_item = Item.highest_revenue(1)

      expect(three_items.length).to eq(3)
      expect(three_items[0]).to eq(items[2])
      expect(three_items[1]).to eq(items[4])
      expect(three_items[2]).to eq(items[3])

      expect(two_items.length).to eq(2)
      expect(two_items[0]).to eq(items[2])
      expect(two_items[1]).to eq(items[4])

      expect(one_item.length).to eq(1)
      expect(one_item[0]).to eq(items[2])
    end

  end

  describe 'Instance Methods' do
  end
end
