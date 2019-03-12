class Customer < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name

  has_many :invoices

  def transactions
    Transaction.joins(:invoice)
              .select('transactions.*, invoices.customer_id')
               .where('invoices.customer_id = ?', self)
  end
end
