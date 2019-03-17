require 'rails_helper'

RSpec.describe 'Item API' do

  it 'sends a list of all items' do
    items = create_list(:item, 5)

    get "/api/v1/items"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"].count).to eq(5)
  end

  it 'sends a single item' do
    id = create(:item).id

    get "/api/v1/items/#{id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"]["id"]).to eq(id.to_s)
  end

  it 'can find a single item by id' do
    item = create(:item)
    item_2 = create(:item)

    get "/api/v1/items/find?id=#{item.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find a single item by name' do
    item = create(:item)
    item_2 = create(:item)

    get "/api/v1/items/find?name=#{item.name}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find a single item by description' do
    item = create(:item, description: 5)
    item_2 = create(:item)

    get "/api/v1/items/find?status=#{item.description}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find a single invoice_item by unit_price' do
    item = create(:item, unit_price: 5)
    item_2 = create(:item)

    get "/api/v1/items/find?unit_price=#{item.unit_price}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find a single item by merchant_id' do
    item = create(:item)
    item_2 = create(:item)

    get "/api/v1/items/find?merchant_id=#{item.merchant_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find a single item by created_at' do
    item = create(:item, created_at: "2012-03-27 14:54:09 UTC")
    item_2 = create(:item, created_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/items/find?created_at=#{item.created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find a single item by updated_at' do
    item = create(:item, updated_at: "2012-03-27 14:54:09 UTC")
    item_2 = create(:item, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/items/find?updated_at=#{item.updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(item.id.to_s)
  end

  it 'can find all items by id' do
    items = create_list(:item, 3)

    get "/api/v1/items/find_all?id=#{items[0].id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["id"]).to eq(items[0].id.to_s)
  end

  it 'can find all items by name' do
    items_1 = create_list(:item, 3, name: "name")
    items_2 = create_list(:item, 3)

    get "/api/v1/items/find_all?name=#{items_1[0].name}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |item|
      expect(item["attributes"]["name"]).to eq(items_1[0].name)
    end
  end

  it 'can find all items by description' do
    items_1 = create_list(:item, 3, description: "this and that and this")
    items_2 = create_list(:item, 3, description: "that and this and that")

    get "/api/v1/items/find_all?description=#{items_1[0].description}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |item|
      expect(item["attributes"]["description"]).to eq(items_1[0].description)
    end
  end

  it 'can find all items by unit_price' do
    price_10 = create_list(:item, 3, unit_price: 10)
    price_1 = create_list(:item, 3)

    get "/api/v1/items/find_all?unit_price=#{price_10[0].unit_price}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |item|
      expect(item["attributes"]["unit_price"]).to eq(price_10[0].unit_price)
    end
  end

  it 'can find all items by merchant_id' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_1_items = create_list(:item, 3, merchant: merchant_1)
    merchant_2_items = create_list(:item, 3, merchant: merchant_2)

    get "/api/v1/items/find_all?merchant_id=#{merchant_1.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)

    json["data"].each do |item|
      expect(item["attributes"]["merchant_id"]).to eq(merchant_1.id)
    end
  end

  it 'can find all items by created_at' do
    items = create_list(:item, 3, created_at: "2012-03-27 14:54:09 UTC")
    other_items = create_list(:item, 3, created_at: "2012-12-27 14:54:09 UTC")

    get "/api/v1/items/find_all?created_at=#{items[0].created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    item_ids = items.map { |m| m.id }
    json["data"].each do |item|
      expect(item_ids).to include(item["attributes"]["id"])
    end
  end

  it 'can find all items by updated_at' do
    items = create_list(:item, 3, updated_at: "2012-03-27 14:54:09 UTC")
    other_items = create_list(:item, 3, updated_at: "2012-05-27 14:54:09 UTC")

    get "/api/v1/items/find_all?updated_at=#{items[0].updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    item_ids = items.map { |m| m.id }
    json["data"].each do |item|
      expect(item_ids).to include(item["attributes"]["id"])
    end
  end

  it 'returns an item at random' do
    items = create_list(:item, 5, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/items/random"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    item_ids = items.map { |m| m.id }
    expect(item_ids).to include(json["data"]["attributes"]["id"])
  end

  it 'returns the associated merchant for an item' do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)

    merchant_2 = create(:merchant)
    item_2 = create(:item, merchant: merchant_2)

    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"].to_i).to eq(merchant.id)
  end

  it 'returns the associated invoice items for an item' do
    item = create(:item)
    invoice_items = create_list(:invoice_item, 4, item: item)

    item_2 = create(:item)
    invoice_items_2 = create_list(:invoice_item, 4, item: item_2)

    get "/api/v1/items/#{item.id}/invoice_items"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(4)
    json["data"].each do |invoice_item|
      expect(invoice_item["attributes"]["item_id"].to_i).to eq(item.id)
    end
  end

  it 'returns requested number of items ordered by highest revenue' do

    items = create_list(:item, 5)
    counter = 1
    items.each do |item|
      invoice = create(:invoice)
      create(:transaction, invoice: invoice, result: 'success')
      create(:invoice_item, item: item, invoice: invoice, unit_price: 1000 * counter, quantity: 10)
      counter += 1
    end
    invoice = create(:invoice)
    create(:transaction, invoice: invoice, result: 'success')
    create(:invoice_item, item: items[2], invoice: invoice, unit_price: 5000 * counter, quantity: 1)

    get "/api/v1/items/most_revenue?quantity=3"
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(3)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(items[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(items[4].id)
    expect(json["data"][2]["attributes"]["id"].to_i).to eq(items[3].id)

    get "/api/v1/items/most_revenue?quantity=2"
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(2)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(items[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(items[4].id)

    get "/api/v1/items/most_revenue?quantity=1"
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(items[2].id)
  end

  it 'returns the requested number of items that have sold the most by quantity' do
    items = create_list(:item, 5)
    counter = 1
    items.each do |item|
      invoice = create(:invoice)
      create(:transaction, invoice: invoice, result: 'success')
      create(:invoice_item, item: item, invoice: invoice, unit_price: 1000, quantity: 10 * counter)
      counter += 1
    end
    invoice = create(:invoice)
    create(:transaction, invoice: invoice, result: 'success')
    create(:invoice_item, item: items[2], invoice: invoice, unit_price: 100, quantity: 25 * counter)

    get "/api/v1/items/most_items?quantity=3"
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(3)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(items[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(items[4].id)
    expect(json["data"][2]["attributes"]["id"].to_i).to eq(items[3].id)

    get "/api/v1/items/most_items?quantity=2"
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(2)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(items[2].id)
    expect(json["data"][1]["attributes"]["id"].to_i).to eq(items[4].id)

    get "/api/v1/items/most_items?quantity=1"
    json = JSON.parse(response.body)

    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["attributes"]["id"].to_i).to eq(items[2].id)
  end

  it 'returns best day for sales of and item' do
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

    get "/api/v1/items/#{item.id}/best_day"

    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["best_day"]).to eq("2012-02-27")
  end

end
