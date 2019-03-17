require 'rails_helper'

RSpec.describe 'Invoices API' do

  it 'sends a list of all invoices' do
    invoices = create_list(:invoice, 5)

    get "/api/v1/invoices"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"].count).to eq(5)
  end

  it 'sends a single invoice' do
    id = create(:invoice).id

    get "/api/v1/invoices/#{id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"]["id"]).to eq(id.to_s)
  end

  it 'can find a single invoice by id' do
    invoice = create(:invoice)
    invoice_2 = create(:invoice)

    get "/api/v1/invoices/find?id=#{invoice.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice.id.to_s)
  end

  it 'can find a single invoice by customer_id' do
    invoice = create(:invoice)
    invoice_2 = create(:invoice)

    get "/api/v1/invoices/find?customer_id=#{invoice.customer_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice.id.to_s)
  end

  it 'can find a single invoice by merchant_id' do
    invoice = create(:invoice)
    invoice_2 = create(:invoice)

    get "/api/v1/invoices/find?merchant_id=#{invoice.merchant_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice.id.to_s)
  end

  it 'can find a single invoice by status' do
    invoice = create(:invoice)
    invoice_2 = create(:invoice)

    get "/api/v1/invoices/find?status=#{invoice.status}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice.id.to_s)
  end

  it 'can find a single invoice by created_at' do
    invoice = create(:invoice, created_at: "2012-03-27 14:54:09 UTC")
    invoice_2 = create(:invoice, created_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/invoices/find?created_at=#{invoice.created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice.id.to_s)
  end

  it 'can find a single invoice by updated_at' do
    invoice = create(:invoice, updated_at: "2012-03-27 14:54:09 UTC")
    invoice_2 = create(:invoice, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/invoices/find?updated_at=#{invoice.updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice.id.to_s)
  end

  it 'can find all invoices by id' do
    invoices = create_list(:invoice, 3)

    get "/api/v1/invoices/find_all?id=#{invoices[0].id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["id"]).to eq(invoices[0].id.to_s)
  end

  it 'can find all invoices by customer_id' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_1s_id = create_list(:invoice, 3, customer: customer_1)
    customer_2s_id = create_list(:invoice, 3, customer: customer_2)

    get "/api/v1/invoices/find_all?customer_id=#{customer_1s_id[0].customer_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice|
      expect(invoice["attributes"]["customer_id"].to_i).to eq(customer_1s_id[0].customer_id)
    end
  end

  it 'can find all invoices by merchant_id' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_1s_id = create_list(:invoice, 3, merchant: merchant_1)
    merchant_2s_id = create_list(:invoice, 3, merchant: merchant_2)

    get "/api/v1/invoices/find_all?merchant_id=#{merchant_1s_id[0].merchant_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice|
      expect(invoice["attributes"]["merchant_id"].to_i).to eq(merchant_1s_id[0].merchant_id)
    end
  end

  it 'can find all invoices by status' do
    shipped_status = create_list(:invoice, 3, status: "shipped")
    pending_status = create_list(:invoice, 3, status: "pending")

    get "/api/v1/invoices/find_all?status=#{shipped_status[0].status}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice|
      expect(invoice["attributes"]["status"]).to eq(shipped_status[0].status)
    end
  end

  it 'can find all invoices by created_at' do
    invoices = create_list(:invoice, 3, created_at: "2012-03-27 14:54:09 UTC")
    other_invoices = create_list(:invoice, 3, created_at: "2012-12-27 14:54:09 UTC")

    get "/api/v1/invoices/find_all?created_at=#{invoices[0].created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    invoice_ids = invoices.map { |m| m.id }
    json["data"].each do |invoice|
      expect(invoice_ids).to include(invoice["attributes"]["id"])
    end
  end

  it 'can find all invoices by updated_at' do
    invoices = create_list(:invoice, 3, updated_at: "2012-03-27 14:54:09 UTC")
    other_invoices = create_list(:invoice, 3, updated_at: "2012-05-27 14:54:09 UTC")

    get "/api/v1/invoices/find_all?updated_at=#{invoices[0].updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    invoice_ids = invoices.map { |m| m.id }
    json["data"].each do |invoice|
      expect(invoice_ids).to include(invoice["attributes"]["id"])
    end
  end

  it 'returns an invoice at random' do
    invoices = create_list(:invoice, 5, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/invoices/random"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    invoice_ids = invoices.map { |m| m.id }
    expect(invoice_ids).to include(json["data"]["attributes"]["id"])
  end

  it 'returns the associated transactions for a invoice' do
    invoice = create(:invoice)
    transactions = create_list(:transaction, 5, invoice: invoice)

    invoice_2 = create(:invoice)
    transactions_2 = create_list(:transaction, 5, invoice: invoice_2)

    get "/api/v1/invoices/#{invoice.id}/transactions"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(5)
    transaction_ids = transactions.map { |i| i.id }
    json["data"].each do |t|
      expect(transaction_ids).to include(t["id"].to_i)
    end
  end

  it 'returns the associated invoice items for a invoice' do
    invoice = create(:invoice)
    invoice_items = create_list(:invoice_item, 5, invoice: invoice)

    invoice_2 = create(:invoice)
    invoice_items_2 = create_list(:invoice_item, 5, invoice: invoice_2)

    get "/api/v1/invoices/#{invoice.id}/invoice_items"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(5)
    invoice_items_ids = invoice_items.map { |i| i.id }
    json["data"].each do |ii|
      expect(invoice_items_ids).to include(ii["id"].to_i)
    end
  end

  it 'returns the associated items for a invoice' do
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

    get "/api/v1/invoices/#{invoice.id}/items"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(5)
    item_ids = items.map { |i| i.id }
    json["data"].each do |item|
      expect(item_ids).to include(item["id"].to_i)
    end
  end
  
  it 'returns the associated customer for a invoice' do
    customer = create(:customer)
    invoice = create(:invoice, customer: customer)

    customer_2 = create(:customer)
    invoice_2 = create(:invoice, customer: customer_2)

    get "/api/v1/invoices/#{invoice.id}/customer"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"]).to eq(customer.id)
  end

  it 'returns the associated merchant for a invoice' do
    merchant = create(:merchant)
    invoice = create(:invoice, merchant: merchant)

    merchant_2 = create(:merchant)
    invoice_2 = create(:invoice, merchant: merchant_2)

    get "/api/v1/invoices/#{invoice.id}/merchant"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"]).to eq(merchant.id)
  end
end
