class Api::V1::Merchants::MostRevenue::QuantityController < ApplicationController

  def index
    @most_revenue = Merchant.most_revenue(params[:quantity])
    render json: TopMerchantsSerializer.new(@most_revenue)
  end

end
