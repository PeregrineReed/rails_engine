class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices

  def revenue_by_date(date)
    invoices.select("sum(unit_price*quantity) AS revenue").joins(:invoice_items, :transactions).merge(Transaction.successful).where(updated_at: Date.parse(date).all_day)[0]
  end
end
