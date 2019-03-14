class Api::V1::Merchants::MostItems::QuantityController < ApplicationController

  def index
    @most_items = Merchant.most_sales(params[:quantity])
    render json: TopMerchantsSerializer.new(@most_items)
  end

end
