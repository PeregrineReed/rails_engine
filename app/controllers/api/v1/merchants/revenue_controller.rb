class Api::V1::Merchants::RevenueController < ApplicationController

  def show
    @merchant_revenue = Merchant.find(params[:merchant_id]).total_revenue
    render json: MerchantRevenueSerializer.new(@merchant_revenue)
  end

end
