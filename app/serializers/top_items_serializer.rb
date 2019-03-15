class TopItemsSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :unit_price
end
