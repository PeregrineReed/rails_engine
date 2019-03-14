require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'returns total revenue for all merchants by invoice date' do

    merchants = create_list(:merchant, 3)
    invoices = []

    counter = 0
    3.times do
      invoices << create(:invoice, merchant: merchants[counter], updated_at: "2012-03-25 12:54:09 UTC")
      invoices << create(:invoice, merchant: merchants[counter], updated_at: "2012-03-25 06:12:20 UTC")
      invoices << create(:invoice, merchant: merchants[counter], updated_at: "2013-03-25 09:54:09 UTC")
      failed_invoices = create_list(:invoice, 3, merchant: merchants[counter], updated_at: "2012-03-25 09:54:09 UTC")

      3.times do
        create(:invoice_item, invoice: invoices[counter], quantity: 5, unit_price: 5000)
        create(:transaction, result: 'success', invoice: invoices[counter])
        create(:transaction, result: 'failed', invoice: failed_invoices[counter])
      end

      counter += 1
    end

    get "/api/v1/merchants/revenue?date=2012-03-25"

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['revenue']).to eq('4500.00')
  end

  it 'returns total revenue for a single merchant by invoice date' do

    merchant = create(:merchant)
    other_merchant = create(:merchant)

    invoices = []
    invoices << create(:invoice, merchant: merchant, updated_at: "2012-03-25 12:54:09 UTC")
    invoices << create(:invoice, merchant: merchant, updated_at: "2012-03-25 06:12:20 UTC")
    invoices << create(:invoice, merchant: merchant, updated_at: "2013-03-25 09:54:09 UTC")
    failed_invoices = create_list(:invoice, 3, merchant: merchant, updated_at: "2012-03-25 09:54:09 UTC")
    other_invoices = create_list(:invoice, 3, merchant: other_merchant, updated_at: "2012-03-25 09:54:09 UTC")

    counter = 0
    3.times do
      create(:invoice_item, invoice: invoices[counter], quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoices[counter])
      create(:transaction, result: 'failed', invoice: failed_invoices[counter])

      create(:invoice_item, invoice: other_invoices[counter], quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: other_invoices[counter])

      counter += 1
    end

    get "/api/v1/merchants/#{merchant.id}/revenue?date=2012-03-25"

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['revenue']).to eq('500.00')
  end
end
