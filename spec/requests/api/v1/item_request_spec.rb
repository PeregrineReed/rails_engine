require 'rails_helper'

RSpec.describe 'Item API' do

  it 'returns requested number of items ordered by highest revenue' do

    items = create_list(:item, 5)
    counter = 1
    items.each do |item|
      invoice = create(:invoice)
      create(:transaction, invoice: invoice, result: 'success')
      counter.times do
        create(:invoice_item, item: item, invoice: invoice, unit_price: 1000 * counter, quantity: 10 * counter)
      end
      counter += 1
    end
    invoice = create(:invoice)
    create(:transaction, invoice: invoice, result: 'success')
    create(:invoice_item, item: items[2], invoice: invoice, unit_price: 5000 * counter, quantity: 25 * counter)

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

end
