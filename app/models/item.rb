class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :unit_price
  belongs_to :merchant
  has_many :invoice_items

  def self.highest_revenue(limit)
    select("items.*, SUM(invoice_items.unit_price*invoice_items.quantity) AS revenue")
    .joins(invoice_items: {invoice: :transactions})
    .merge(Transaction.successful)
    .group(:id)
    .order('revenue DESC')
    .limit(limit)
  end

  def self.most_sold(limit)
    select("items.*, SUM(invoice_items.quantity) AS items_sold")
    .joins(invoice_items: {invoice: :transactions})
    .merge(Transaction.successful)
    .group(:id)
    .order('items_sold DESC')
    .limit(limit)
  end

  def self.best_day(id)
    select("items.id, CAST(invoices.updated_at AS DATE) as day, SUM(invoice_items.quantity) AS sales")
    .joins(invoice_items: {invoice: :transactions})
    .merge(Transaction.successful)
    .where('items.id = ?', id)
    .group('invoices.updated_at, items.id')
    .order('sales DESC, day DESC')[0]
  end

end
