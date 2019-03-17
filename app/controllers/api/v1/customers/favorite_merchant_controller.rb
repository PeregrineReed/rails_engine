class Api::V1::Customers::FavoriteMerchantController < ApplicationController

  def show
    @customer = Customer.find(params['customer_id'])
    render json: MerchantSerializer.new(@customer.favorite_merchant)
  end

end
