require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'returns defined number of merchants ordered by most revenue' do
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

    get '/api/v1/merchants/most_revenue?quantity=3'

    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(3)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(merchants[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(merchants[1].id)
    expect(json["data"][2]["attributes"]["id"].to_i).to eq(merchants[0].id)

    get '/api/v1/merchants/most_revenue?quantity=2'

    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(2)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(merchants[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(merchants[1].id)

    get '/api/v1/merchants/most_revenue?quantity=1'

    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(merchants[2].id)
  end

  it 'returns defined number of merchants ordered by most sales' do
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

    get '/api/v1/merchants/most_items?quantity=3'

    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(3)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(merchants[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(merchants[1].id)
    expect(json["data"][2]["attributes"]["id"].to_i).to eq(merchants[0].id)

    get '/api/v1/merchants/most_items?quantity=2'

    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(2)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(merchants[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(merchants[1].id)

    get '/api/v1/merchants/most_items?quantity=1'

    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(merchants[2].id)
  end

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

    expect(json['data']['attributes']['total_revenue']).to eq('4500.00')
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
