class Api::V1::Items::MostItems::QuantityController < ApplicationController

  def index
    render json: TopItemsSerializer.new(Item.most_sold(params[:quantity]))
  end

end
