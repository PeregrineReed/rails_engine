FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { 1 }
    created_at { "2012-03-27 14:54:09 UTC" }
    updated_at { "2012-03-27 14:54:09 UTC" }
  end
end
