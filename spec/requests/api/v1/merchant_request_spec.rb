require 'rails_helper'

RSpec.describe 'Merchants API' do

  it 'sends a list of all merchants' do
    merchants = create_list(:merchant, 5)

    get "/api/v1/merchants"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"].count).to eq(5)
  end

  it 'sends a single merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"]["id"]).to eq(id.to_s)
  end

  it 'can find a single merchant by id' do

    merchant = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(merchant.id.to_s)

  end

  it 'can find a single merchant by name' do

    merchant = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?name=#{merchant.name}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(merchant.id.to_s)

  end

  it 'can find a single merchant by created_at' do

    merchant = create(:merchant, created_at: "2012-03-27 14:54:09 UTC")
    merchant_2 = create(:merchant, created_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(merchant.id.to_s)

  end

  it 'can find a single merchant by updated_at' do

    merchant = create(:merchant, updated_at: "2012-03-27 14:54:09 UTC")
    merchant_2 = create(:merchant, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(merchant.id.to_s)

  end

  it 'can find all merchants by id' do

    merchants = create_list(:merchant, 3)

    get "/api/v1/merchants/find_all?id=#{merchants[0].id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["id"]).to eq(merchants[0].id.to_s)

  end

  it 'can find all merchants by name' do

    names = create_list(:merchant, 3, name: "Name")
    no_names = create_list(:merchant, 3, name: "No Name")

    get "/api/v1/merchants/find_all?name=#{names[0].name}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |merchant|
      expect(merchant["attributes"]["name"]).to eq("Name")
    end
  end

  it 'can find all merchants by created_at' do

    merchants = create_list(:merchant, 3, created_at: "2012-03-27 14:54:09 UTC")
    other_merchants = create_list(:merchant, 3, created_at: "2012-12-27 14:54:09 UTC")

    get "/api/v1/merchants/find_all?created_at=#{merchants[0].created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    merchant_ids = merchants.map { |m| m.id }
    json["data"].each do |merchant|
      expect(merchant_ids).to include(merchant["attributes"]["id"])
    end
  end

  it 'can find all merchants by updated_at' do

    merchants = create_list(:merchant, 3, updated_at: "2012-03-27 14:54:09 UTC")
    other_merchants = create_list(:merchant, 3, updated_at: "2012-05-27 14:54:09 UTC")

    get "/api/v1/merchants/find_all?updated_at=#{merchants[0].updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    merchant_ids = merchants.map { |m| m.id }
    json["data"].each do |merchant|
      expect(merchant_ids).to include(merchant["attributes"]["id"])
    end
  end

  it 'returns a merchant at random' do

    merchants = create_list(:merchant, 5, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/merchants/random"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    merchant_ids = merchants.map { |m| m.id }
    expect(merchant_ids).to include(json["data"]["attributes"]["id"])
  end

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

  it 'returns total revenue for a single merchant' do
    merchant = create(:merchant)
    3.times do
      invoice = create(:invoice, merchant: merchant)
      create(:invoice_item, invoice: invoice, quantity: 5, unit_price: 5000)
      create(:transaction, result: 'success', invoice: invoice)
    end
    fail = create(:invoice, merchant: merchant)
    create(:invoice_item, invoice: fail, quantity: 5, unit_price: 5000)
    create(:transaction, result: 'failed', invoice: fail)

    get "/api/v1/merchants/#{merchant.id}/revenue"

    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["revenue"]).to eq("750.00")
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

  it 'returns favorite customer for a merchant' do
    merchant = create(:merchant)
    merchant_2 = create(:merchant)
    customers = create_list(:customer, 5)

    counter = 1
    customers.each do |customer|
      counter.times do
        invoice = create(:invoice, merchant: merchant, customer: customer)
        create(:transaction, invoice: invoice)
      end
      counter += 1
    end

    counter = 1
    customers.reverse.each do |customer|
      counter.times do
        invoice = create(:invoice, merchant: merchant_2, customer: customer)
        create(:transaction, invoice: invoice)
      end
      counter += 1
    end

    get "/api/v1/merchants/#{merchant.id}/favorite_customer"

    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"].to_i).to eq(customers.last.id)

    get "/api/v1/merchants/#{merchant_2.id}/favorite_customer"

    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"].to_i).to eq(customers.first.id)
  end
end
