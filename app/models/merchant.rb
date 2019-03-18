class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices

  default_scope { order(:id) }

  def self.most_revenue(limit)
    unscoped
    .select("merchants.*, SUM(unit_price*quantity) AS revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.unscoped.successful)
    .group(:id)
    .order("revenue DESC")
    .limit(limit)
  end

  def self.most_sales(limit)
    unscoped
    .select("merchants.*, SUM(quantity) AS items_sold")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.unscoped.successful)
    .group(:id)
    .order("items_sold DESC")
    .limit(limit)
  end

  def self.revenue_by_date(date)
    unscoped
    .select("sum(unit_price*quantity) AS revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.unscoped.successful)
    .where(invoices: {updated_at: Date.parse(date).all_day})[0]
  end

  def total_revenue
    invoices
    .unscoped
    .select("sum(unit_price*quantity) AS revenue")
    .joins(:invoice_items, :transactions)
    .merge(Transaction.unscoped.successful)
    .where(merchant: self)[0]
  end

  def revenue_by_date(date)
    invoices
    .unscoped
    .select("sum(unit_price*quantity) AS revenue")
    .joins(:invoice_items, :transactions)
    .merge(Transaction.unscoped.successful)
    .where(updated_at: Date.parse(date).all_day, merchant: self)[0]
  end

  def favorite_customer
    Customer.unscoped
            .joins(invoices: [:merchant, :transactions])
            .select("customers.*, count(transactions) AS transaction_count")
            .merge(Transaction.unscoped.successful)
            .where(merchants: {id: self.id})
            .group('customers.id')
            .order('transaction_count DESC')
            .first
  end
end
