require 'csv'

namespace :import do
  desc "Import customers"

  task customers: :environment do
    CSV.foreach('../sales_engine/data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
  end

  desc "Import invoice items"

  task invoice_items: :environment do
    CSV.foreach('../sales_engine/data/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
  end

  desc "Import invoices"

  task invoices: :environment do
    CSV.foreach('../sales_engine/data/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
  end

  desc "Import items"

  task items: :environment do
    CSV.foreach('../sales_engine/data/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
  end

  desc "Import merchants"

  task merchants: :environment do
    CSV.foreach('../sales_engine/data/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
  end

  desc "Import transactions"

  task transactions: :environment do
    CSV.foreach('../sales_engine/data/transactions.csv', headers: true) do |row|
      Transaction.create(row.to_h)
    end
  end
end
