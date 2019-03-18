class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number,
                        :result

  belongs_to :invoice

  enum result: [:success, :failed]

  default_scope { order(:id) }
  scope :successful, -> { where(result: "success") }
end
