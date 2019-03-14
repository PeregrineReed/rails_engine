class TopMerchantsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name
end
