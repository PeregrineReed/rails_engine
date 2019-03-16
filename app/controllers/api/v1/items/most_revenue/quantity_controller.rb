class Api::V1::Items::MostRevenue::QuantityController < ApplicationController

  def index
    render json: TopItemsSerializer.new(Item.highest_revenue(params[:quantity]))
  end

end
