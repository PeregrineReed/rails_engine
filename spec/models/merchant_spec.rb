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

    it "::most_revenue(limit)" do
      merchants = create_list(:merchant, 4)
      invoices = []

      counter = 0
      3.times do
        invoices << create(:invoice, merchant: merchants[counter])
        (counter + 1).times do
          create(:invoice_item, invoice: invoices.last, quantity: 5, unit_price: 2000 * (counter + 1))
          create(:invoice_item, invoice: invoices.last, quantity: 10, unit_price: 1000 * (counter + 1))
          create(:transaction, result: 'success', invoice: invoices.last)
        end
        counter += 1
      end

      invoices << create(:invoice, merchant: merchants[3])
      create(:invoice_item, invoice: invoices.last, quantity: 2, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoices.last)

      three_merchants = Merchant.most_revenue(3)
      two_merchants = Merchant.most_revenue(2)
      one_merchant = Merchant.most_revenue(1)

      expect(three_merchants.length).to eq(3)
      expect(three_merchants[0]).to eq(merchants[2])
      expect(three_merchants[1]).to eq(merchants[1])
      expect(three_merchants[2]).to eq(merchants[0])

      expect(two_merchants.length).to eq(2)
      expect(three_merchants[0]).to eq(merchants[2])
      expect(three_merchants[1]).to eq(merchants[1])

      expect(one_merchant.length).to eq(1)
      expect(three_merchants[0]).to eq(merchants[2])
    end

    it "::most_sales(limit)" do
      merchants = create_list(:merchant, 4)
      invoices = []

      counter = 0
      3.times do
        invoices << create(:invoice, merchant: merchants[counter])
        (counter + 1).times do
          create(:invoice_item, invoice: invoices.last, quantity: 5 * (counter + 1), unit_price: 2000)
          create(:invoice_item, invoice: invoices.last, quantity: 10 * (counter + 1), unit_price: 1000)
          create(:transaction, result: 'success', invoice: invoices.last)
        end
        counter += 1
      end

      invoices << create(:invoice, merchant: merchants[3])
      create(:invoice_item, invoice: invoices.last, quantity: 2, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoices.last)

      three_merchants = Merchant.most_sales(3)
      two_merchants = Merchant.most_sales(2)
      one_merchant = Merchant.most_sales(1)

      expect(three_merchants.length).to eq(3)
      expect(three_merchants[0]).to eq(merchants[2])
      expect(three_merchants[1]).to eq(merchants[1])
      expect(three_merchants[2]).to eq(merchants[0])

      expect(two_merchants.length).to eq(2)
      expect(three_merchants[0]).to eq(merchants[2])
      expect(three_merchants[1]).to eq(merchants[1])

      expect(one_merchant.length).to eq(1)
      expect(three_merchants[0]).to eq(merchants[2])
    end

    it "::revenue_by_date(date)" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      invoice_1 = create(:invoice, merchant: merchant_1, updated_at: "2012-03-25 11:54:29 UTC")
      create(:invoice_item, invoice: invoice_1, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice_1)
      invoice_2 = create(:invoice, merchant: merchant_2, updated_at: "2012-03-25 09:04:09 UTC")
      create(:invoice_item, invoice: invoice_2, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice_2)
      invoice_3 = create(:invoice, merchant: merchant_3, updated_at: "2012-03-25 02:59:19 UTC")
      create(:invoice_item, invoice: invoice_3, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice_3)
      invoice_4 = create(:invoice, merchant: merchant_3, updated_at: "2012-04-25 09:54:09 UTC")
      create(:invoice_item, invoice: invoice_4, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice_4)

      expect(Merchant.revenue_by_date("2012-03-25").revenue).to eq(75000)
    end

  end

  describe 'Instance Methods' do

    it "#total_revenue" do
      merchant = create(:merchant)
      3.times do
        invoice = create(:invoice, merchant: merchant)
        create(:invoice_item, invoice: invoice, quantity: 5, unit_price: 5000)
        create(:transaction, result: 'success', invoice: invoice)
      end
      fail = create(:invoice, merchant: merchant)
      create(:invoice_item, invoice: fail, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'failed', invoice: fail)

      expect((merchant.total_revenue).revenue).to eq(75000)
    end

    it "#revenue_by_date(date)" do
      merchant = create(:merchant)

      invoice = create(:invoice, merchant: merchant, updated_at: "2012-03-25 09:54:09 UTC")
      create(:invoice_item, invoice: invoice, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice)

      fail = create(:invoice, merchant: merchant, updated_at: "2012-03-25 09:54:09 UTC")
      create(:invoice_item, invoice: fail, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'failed', invoice: fail)

      expect(merchant.revenue_by_date("2012-03-25").revenue).to eq(25000)
    end

    it "#favorite_customer" do
      merchant = create(:merchant)

      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)

      invoices_1 = create_list(:invoice, 3, customer: customer_1, merchant: merchant)
      invoices_2 = create_list(:invoice, 2, customer: customer_2, merchant: merchant)
      transaction_1 = create(:transaction, invoice: invoices_1[0])
      transaction_2 = create(:transaction, invoice: invoices_1[1])
      transaction_3 = create(:transaction,  invoice: invoices_1[2])
      transactions_4_5_6 = create_list(:transaction, 3, invoice: invoices_2[0])
      transactions_5_6_7 = create_list(:transaction, 3, invoice: invoices_2[1])

      expected = customer_2
      actual = merchant.favorite_customer

      expect(actual).to eq(expected)
    end
  end
end
