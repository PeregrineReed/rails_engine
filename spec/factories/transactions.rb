FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { "1000100010001000" }
    credit_card_expiration_date { "2012-12-21" }
    result { 0 }
  end
end
