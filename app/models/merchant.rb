class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices

  def self.most_revenue(limit)
    select("merchants.*, SUM(unit_price*quantity) AS revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("revenue DESC")
    .limit(limit)
  end

  def self.most_sales(limit)
    select("merchants.*, COUNT(quantity) AS items_sold")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .group(:id)
    .order("items_sold DESC")
    .limit(limit)
  end

  def self.revenue_by_date(date)
    select("sum(unit_price*quantity) AS revenue")
    .joins(invoices: [:invoice_items, :transactions])
    .merge(Transaction.successful)
    .where(invoices: {updated_at: Date.parse(date).all_day})[0]
  end

  def revenue_by_date(date)
    invoices.select("sum(unit_price*quantity) AS revenue")
    .joins(:invoice_items, :transactions)
    .merge(Transaction.successful)
    .where(updated_at: Date.parse(date).all_day)[0]
  end
end
