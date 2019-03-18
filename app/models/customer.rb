class Customer < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name

  has_many :invoices

  default_scope { order(:id) }

  def transactions
    Transaction.unscoped
    .joins(:invoice)
    .select('transactions.*, invoices.customer_id')
    .where('invoices.customer_id = ?', self)
  end

  def favorite_merchant
    # merchant, sum of transactions from a single customer
    Merchant.unscoped
            .joins(invoices: [:customer, :transactions])
            .select("merchants.*, count(transactions) AS transaction_count")
            .merge(Transaction.unscoped.successful)
            .where(customers: {id: self.id})
            .group('merchants.id')
            .order('transaction_count DESC')
            .limit(1).first
  end
end
