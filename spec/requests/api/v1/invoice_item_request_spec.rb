require 'rails_helper'

RSpec.describe 'Invoice Items API' do

  it 'sends a list of all invoice items' do
    invoice_items = create_list(:invoice_item, 5)

    get "/api/v1/invoice_items"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"].count).to eq(5)
  end

  it 'sends a single invoice item' do
    id = create(:invoice_item).id

    get "/api/v1/invoice_items/#{id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"]["id"]).to eq(id.to_s)
  end

  it 'can find a single invoice item by id' do
    invoice_item = create(:invoice_item)
    invoice_item_2 = create(:invoice_item)

    get "/api/v1/invoice_items/find?id=#{invoice_item.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find a single invoice item by invoice_id' do
    invoice_item = create(:invoice_item)
    invoice_item_2 = create(:invoice_item)

    get "/api/v1/invoice_items/find?invoice_id=#{invoice_item.invoice_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find a single invoice item by item_id' do
    invoice_item = create(:invoice_item)
    invoice_item_2 = create(:invoice_item)

    get "/api/v1/invoice_items/find?item_id=#{invoice_item.item_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find a single invoice item by quantity' do
    invoice_item = create(:invoice_item, quantity: 5)
    invoice_item_2 = create(:invoice_item)

    get "/api/v1/invoice_items/find?status=#{invoice_item.quantity}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find a single invoice item by unit_price' do
    invoice_item = create(:invoice_item, unit_price: 5)
    invoice_item_2 = create(:invoice_item)

    get "/api/v1/invoice_items/find?unit_price=#{invoice_item.unit_price}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find a single invoice item by created_at' do
    invoice_item = create(:invoice_item, created_at: "2012-03-27 14:54:09 UTC")
    invoice_item_2 = create(:invoice_item, created_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/invoice_items/find?created_at=#{invoice_item.created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find a single invoice item by updated_at' do
    invoice_item = create(:invoice_item, updated_at: "2012-03-27 14:54:09 UTC")
    invoice_item_2 = create(:invoice_item, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/invoice_items/find?updated_at=#{invoice_item.updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(invoice_item.id.to_s)
  end

  it 'can find all invoice items by id' do
    invoice_items = create_list(:invoice_item, 3)

    get "/api/v1/invoice_items/find_all?id=#{invoice_items[0].id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["id"]).to eq(invoice_items[0].id.to_s)
  end

  it 'can find all invoice items by invoice_id' do
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_items_1 = create_list(:invoice_item, 3, invoice: invoice_1)
    invoice_items_2 = create_list(:invoice_item, 3, invoice: invoice_2)

    get "/api/v1/invoice_items/find_all?invoice_id=#{invoice_items_1[0].invoice_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice_item|
      expect(invoice_item["attributes"]["invoice_id"].to_i).to eq(invoice_items_1[0].invoice_id)
    end
  end

  it 'can find all invoice items by item_id' do
    item_1 = create(:item)
    item_2 = create(:item)
    invoice_items_1 = create_list(:invoice_item, 3, item: item_1)
    invoice_items_2 = create_list(:invoice_item, 3, item: item_2)

    get "/api/v1/invoice_items/find_all?item_id=#{invoice_items_1[0].item_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice_item|
      expect(invoice_item["attributes"]["item_id"].to_i).to eq(invoice_items_1[0].item_id)
    end
  end

  it 'can find all invoice items by quantity' do
    price_10 = create_list(:invoice_item, 3, quantity: 5)
    qty_1 = create_list(:invoice_item, 3)

    get "/api/v1/invoice_items/find_all?quantity=#{price_10[0].quantity}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice_item|
      expect(invoice_item["attributes"]["quantity"]).to eq(price_10[0].quantity)
    end
  end

  it 'can find all invoice items by unit_price' do
    price_10 = create_list(:invoice_item, 3, unit_price: 10)
    price_1 = create_list(:invoice_item, 3)

    get "/api/v1/invoice_items/find_all?unit_price=#{price_10[0].unit_price}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |invoice_item|
      expect(invoice_item["attributes"]["unit_price"]).to eq(price_10[0].unit_price)
    end
  end

  it 'can find all invoice items by created_at' do
    invoice_items = create_list(:invoice_item, 3, created_at: "2012-03-27 14:54:09 UTC")
    other_invoice_items = create_list(:invoice_item, 3, created_at: "2012-12-27 14:54:09 UTC")

    get "/api/v1/invoice_items/find_all?created_at=#{invoice_items[0].created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    invoice_item_ids = invoice_items.map { |m| m.id }
    json["data"].each do |invoice_item|
      expect(invoice_item_ids).to include(invoice_item["attributes"]["id"])
    end
  end

  it 'can find all invoice items by updated_at' do
    invoice_items = create_list(:invoice_item, 3, updated_at: "2012-03-27 14:54:09 UTC")
    other_invoice_items = create_list(:invoice_item, 3, updated_at: "2012-05-27 14:54:09 UTC")

    get "/api/v1/invoice_items/find_all?updated_at=#{invoice_items[0].updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    invoice_item_ids = invoice_items.map { |m| m.id }
    json["data"].each do |invoice_item|
      expect(invoice_item_ids).to include(invoice_item["attributes"]["id"])
    end
  end

  it 'returns an invoice item at random' do
    invoice_items = create_list(:invoice_item, 5, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/invoice_items/random"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    invoice_item_ids = invoice_items.map { |m| m.id }
    expect(invoice_item_ids).to include(json["data"]["attributes"]["id"])
  end

  it 'returns the associated invoice for an invoice item' do
    invoice = create(:invoice)
    invoice_item = create(:invoice_item, invoice: invoice)

    invoice_2 = create(:invoice)
    invoice_item_2 = create(:invoice_item, invoice: invoice_2)

    get "/api/v1/invoice_items/#{invoice_item.id}/invoice"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"].to_i).to eq(invoice.id)
  end

  it 'returns the associated item for an invoice item' do
    item = create(:item)
    invoice_item = create(:invoice_item, item: item)

    item_2 = create(:item)
    invoice_item_2 = create(:invoice_item, item: item_2)

    get "/api/v1/invoice_items/#{invoice_item.id}/item"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"].to_i).to eq(item.id)
  end

end
