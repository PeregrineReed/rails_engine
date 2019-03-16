require 'rails_helper'

RSpec.describe 'Item API' do

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
