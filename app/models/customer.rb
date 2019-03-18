class Customer < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name

  has_many :invoices

  default_scope { order(:id) }

  def self.with_pending_invoices(merchant_id)
    unscoped
    .find_by_sql(
      "SELECT customers.*
         FROM customers
         JOIN invoices ON invoices.customer_id = customers.id
         JOIN merchants ON invoices.merchant_id = merchants.id
         JOIN transactions ON transactions.invoice_id = invoices.id
         WHERE invoices.status = 1
              AND transactions.result = 1
              AND merchants.id = #{merchant_id}
         GROUP BY customers.id"
       )
  end

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
