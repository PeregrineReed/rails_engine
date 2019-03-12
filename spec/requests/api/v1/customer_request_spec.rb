require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of all customers' do
    customers = create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end
end
