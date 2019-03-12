require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe 'Relationships' do
    it { should have_many :invoices }
  end

  describe 'Validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'Class Methods' do
  end

  describe 'Instance Methods' do

    it '#transactions' do
      customer = create(:customer)
      other_customer = create(:customer)
      merchant = create(:merchant)
      invoices = create_list(:invoice, 3, customer: customer)
      invoice_1_transactions = create_list(:transaction, 3, invoice: invoices[0])
      invoice_2_transactions = create_list(:transaction, 3, invoice: invoices[1])
      invoice_3_transactions = create_list(:transaction, 3, invoice: invoices[2])
      transactions = []
      transactions << invoice_1_transactions
      transactions << invoice_2_transactions
      transactions << invoice_3_transactions
      transactions.flatten
      other_invoices = create_list(:invoice, 3, customer: other_customer)
      other_invoice_transactions = create_list(:transaction, 3, invoice: other_invoices[0])

      expected = transactions
      actual = customer.transactions

      expect(actual).to eq(expected)
    end

    it '#favorite_merchant' do
      customer = create(:customer)

      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)

      invoices_1 = create_list(:invoice, 3, customer: customer, merchant: merchant_1)
      invoices_2 = create_list(:invoice, 2, customer: customer, merchant: merchant_2)
      transaction_1 = create(:transaction, invoice: invoices_1[0])
      transaction_2 = create(:transaction, invoice: invoices_1[1])
      transaction_3 = create(:transaction,  invoice: invoices_1[2])
      transactions_4_5_6 = create_list(:transaction, 3, invoice: invoices_2[0])
      transactions_5_6_7 = create_list(:transaction, 3, invoice: invoices_2[1])

      expected = merchant_2
      actual = customer.favorite_merchant

      expect(actual).to eq(expected)
    end

  end

end
