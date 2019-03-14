require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'Relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'Validations' do
    it { should validate_presence_of :name }
  end

  describe 'Class Methods' do
  end

  describe 'Instance Methods' do
    it ".revenue_by_date(date)" do
      merchant = create(:merchant)
      invoice = create(:invoice, merchant: merchant, updated_at: "2012-03-25 09:54:09 UTC")
      create(:invoice_item, invoice: invoice, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice)

      expect(merchant.revenue_by_date("2012-03-25").revenue).to eq(25000)
    end
  end
end
