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
        create(:transaction, invoice: invoice)
        create(:invoice_item, item: item, invoice: invoice, unit_price: 1000 * counter, quantity: 10)
        counter += 1
      end
      invoice = create(:invoice)
      create(:transaction, invoice: invoice)
      create(:invoice_item, item: items[2], invoice: invoice, unit_price: 5000 * counter, quantity: 1)

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

    it '::most_sold(limit)' do
      items = create_list(:item, 5)
      counter = 1
      items.each do |item|
        invoice = create(:invoice)
        create(:transaction, invoice: invoice)
        create(:invoice_item, item: item, invoice: invoice, unit_price: 1000, quantity: 10 * counter)
        counter += 1
      end
      invoice = create(:invoice)
      create(:transaction, invoice: invoice)
      create(:invoice_item, item: items[2], invoice: invoice, unit_price: 100, quantity: 25 * counter)

      three_items = Item.most_sold(3)
      two_items = Item.most_sold(2)
      one_item = Item.most_sold(1)

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

    it '::best_day(item_id)' do
      item = create(:item)
      other_item = create(:item)

      counter = 5
      counter.times do
        invoice = create(:invoice, updated_at: "2012-0#{counter}-27 14:54:09 UTC")
        create(:transaction, invoice: invoice)
        create(:invoice_item, item: item, invoice: invoice, quantity: 5)

        other_invoice = create(:invoice, updated_at: "2012-0#{counter}-27 14:54:09 UTC")
        create(:transaction, invoice: other_invoice)
        create(:invoice_item, item: other_item, invoice: other_invoice, quantity: 5)
        counter -= 1
      end
      invoice = create(:invoice, updated_at: "2012-02-27 14:54:09 UTC")
      create(:transaction, invoice: invoice)
      create(:invoice_item, item: item, invoice: invoice, quantity: 5)
      invoice = create(:invoice, updated_at: "2012-01-27 14:54:09 UTC")
      create(:transaction, invoice: invoice)
      create(:invoice_item, item: item, invoice: invoice, quantity: 5)

      other_invoice = create(:invoice, updated_at: "2012-03-27 14:54:09 UTC")
      create(:transaction, invoice: other_invoice)
      create(:invoice_item, item: other_item, invoice: other_invoice, quantity: 25)

      result = Item.best_day(item.id)
      expect(result.class).to eq(Item)
      expect(result.best_day.to_s).to eq("2012-02-27")
    end

    it '::where_invoice(invoice)' do
      invoice = create(:invoice)
      items = create_list(:item, 5)
      items.each do |item|
        create(:invoice_item, invoice: invoice, item: item)
      end

      invoice_2 = create(:invoice)
      items_2 = create_list(:item, 5)
      items.each do |item|
        create(:invoice_item, invoice: invoice_2, item: item)
      end

      expect(Item.where_invoice(invoice)).to eq(items)
    end

  end

  describe 'Instance Methods' do
  end
end
