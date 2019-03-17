require 'rails_helper'

RSpec.describe 'Tranaction API' do

  it 'sends a list of all transactions' do
    transactions = create_list(:transaction, 5)

    get "/api/v1/transactions"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"].count).to eq(5)
  end

  it 'sends a single transaction' do
    id = create(:transaction).id

    get "/api/v1/transactions/#{id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json["data"]["id"]).to eq(id.to_s)
  end

  it 'can find a single transaction by id' do
    transaction = create(:transaction)
    transaction_2 = create(:transaction)

    get "/api/v1/transactions/find?id=#{transaction.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end

  it 'can find a single transaction by invoice_id' do
    transaction = create(:transaction)
    transaction_2 = create(:transaction)

    get "/api/v1/transactions/find?invoice_id=#{transaction.invoice_id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end

  it 'can find a single transaction by credit_card_number' do
    transaction = create(:transaction)
    transaction_2 = create(:transaction)

    get "/api/v1/transactions/find?credit_card_number=#{transaction.credit_card_number}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end

  it 'can find a single transaction by credit_card_expiration_date' do
    transaction = create(:transaction, credit_card_expiration_date: "2019-07-31")
    transaction_2 = create(:transaction)

    get "/api/v1/transactions/find?credit_card_expiration_date=#{transaction.credit_card_expiration_date}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end
  it 'can find a single transaction by result' do
    transaction = create(:transaction)
    transaction_2 = create(:transaction)

    get "/api/v1/transactions/find?result=#{transaction.result}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end

  it 'can find a single transaction by created_at' do
    transaction = create(:transaction, created_at: "2012-03-27 14:54:09 UTC")
    transaction_2 = create(:transaction, created_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/transactions/find?created_at=#{transaction.created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end

  it 'can find a single transaction by updated_at' do
    transaction = create(:transaction, updated_at: "2012-03-27 14:54:09 UTC")
    transaction_2 = create(:transaction, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/transactions/find?updated_at=#{transaction.updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"]["id"]).to eq(transaction.id.to_s)
  end

  it 'can find all transactions by id' do
    transactions = create_list(:transaction, 3)

    get "/api/v1/transactions/find_all?id=#{transactions[0].id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(1)
    expect(json["data"][0]["id"]).to eq(transactions[0].id.to_s)
  end

  it 'can find all transactions by invoice_id' do
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_1_transactions = create_list(:transaction, 3, invoice: invoice_1)
    invoice_2_transactions = create_list(:transaction, 3, invoice: invoice_2)

    get "/api/v1/transactions/find_all?invoice_id=#{invoice_1.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |transaction|
      expect(transaction["attributes"]["invoice_id"].to_i).to eq(invoice_1.id)
    end
  end

  it 'can find all transactions by credit_card_number' do
    transactions_1 = create_list(:transaction, 3, credit_card_number: "0000000000000000")
    transactions_2 = create_list(:transaction, 3, credit_card_number: "1212232334344545")

    get "/api/v1/transactions/find_all?credit_card_number=#{transactions_1[0].credit_card_number}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |transaction|
      expect(transaction["attributes"]["credit_card_number"]).to eq(transactions_1[0].credit_card_number)
    end
  end

  it 'can find all transactions by credit_card_expiration_date' do
    credit_card_expiration_date_1 = create_list(:transaction, 3, credit_card_expiration_date: "2012-03-31")
    credit_card_expiration_date_2 = create_list(:transaction, 3, credit_card_expiration_date: "2020-03-31")

    get "/api/v1/transactions/find_all?credit_card_expiration_date=#{credit_card_expiration_date_1[0].credit_card_expiration_date}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |transaction|
      expect(transaction["attributes"]["credit_card_expiration_date"]).to eq(credit_card_expiration_date_1[0].credit_card_expiration_date)
    end
  end

  it 'can find all transactions by result' do
    result_success = create_list(:transaction, 3, result: "success")
    result_failed = create_list(:transaction, 3, result: "failed")

    get "/api/v1/transactions/find_all?result=#{result_success[0].result}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    json["data"].each do |transaction|
      expect(transaction["attributes"]["result"]).to eq(result_success[0].result)
    end
  end

  it 'can find all transactions by created_at' do
    transactions = create_list(:transaction, 3, created_at: "2012-03-27 14:54:09 UTC")
    other_transactions = create_list(:transaction, 3, created_at: "2012-12-27 14:54:09 UTC")

    get "/api/v1/transactions/find_all?created_at=#{transactions[0].created_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    transaction_ids = transactions.map { |t| t.id }
    json["data"].each do |transaction|
      expect(transaction_ids).to include(transaction["attributes"]["id"])
    end
  end

  it 'can find all transactions by updated_at' do
    transactions = create_list(:transaction, 3, updated_at: "2012-03-27 14:54:09 UTC")
    other_transactions = create_list(:transaction, 3, updated_at: "2012-05-27 14:54:09 UTC")

    get "/api/v1/transactions/find_all?updated_at=#{transactions[0].updated_at}"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json["data"].length).to eq(3)
    transaction_ids = transactions.map { |t| t.id }
    json["data"].each do |transaction|
      expect(transaction_ids).to include(transaction["attributes"]["id"])
    end
  end

  it 'returns a transaction at random' do
    transactions = create_list(:transaction, 5, updated_at: "2012-03-27 14:54:09 UTC")

    get "/api/v1/transactions/random"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    transaction_ids = transactions.map { |t| t.id }
    expect(transaction_ids).to include(json["data"]["attributes"]["id"])
  end

  it 'returns the associated invoice for a transaction' do
    invoice = create(:invoice)
    transaction = create(:transaction, invoice: invoice)

    invoice_2 = create(:invoice)
    transaction_2 = create(:transaction, invoice: invoice_2)

    get "/api/v1/transactions/#{transaction.id}/invoice"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json["data"]["attributes"]["id"].to_i).to eq(invoice.id)
  end
end
