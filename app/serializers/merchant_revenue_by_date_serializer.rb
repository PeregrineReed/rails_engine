class MerchantRevenueByDateSerializer
  include FastJsonapi::ObjectSerializer
  attribute :revenue do |object|
    '%.2f' % (object.revenue / 100.0)
  end
end
