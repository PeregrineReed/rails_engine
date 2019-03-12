require 'rails_helper'

describe 'Customers API' do
  it 'sends a list of all customers' do
    customers = create_list(:customer, 3)

    get '/api/v1/customers'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it 'sends a single customer by id' do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["id"]).to eq(id)
  end

  it 'sends a customer by finding id' do
    customer = create(:customer)

    get "/api/v1/customers/find?id=#{customer.id}"

    json = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json["id"]).to eq(customer.id)
  end

  it 'sends a customer by finding first name' do
    customer = create(:customer)

    get "/api/v1/customers/find?first_name=#{customer.first_name}"

    json = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json["first_name"]).to eq(customer.first_name)
  end

  it 'sends a customer by finding last name' do
    customer = create(:customer)

    get "/api/v1/customers/find?last_name=#{customer.last_name}"

    json = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json["last_name"]).to eq(customer.last_name)
  end

  it 'sends a customer by finding created at' do
    customer = create(:customer)

    get "/api/v1/customers/find?created_at=#{customer.created_at}"

    json = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json["created_at"]).to eq(customer.created_at)
  end

  it 'sends a customer by finding updated at' do
    customer = create(:customer)

    get "/api/v1/customers/find?updated_at=#{customer.updated_at}"

    json = JSON.parse(response.body)

    expect(response).to be_successful
    expect(json["updated_at"]).to eq(customer.updated_at)
  end
end
