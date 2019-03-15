class TotalRevenueByDateSerializer
  include FastJsonapi::ObjectSerializer
  attribute :total_revenue do |object|
    '%.2f' % (object.revenue / 100.0)
  end
end
