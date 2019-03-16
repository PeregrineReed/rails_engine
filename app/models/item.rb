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

end
