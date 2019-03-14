class Api::V1::Merchants::Revenue::DateController < ApplicationController

  def index
    render json: MerchantRevenueByDateSerializer.new(Merchant.revenue_by_date(params[:date]))
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    render json: MerchantRevenueByDateSerializer.new(@merchant.revenue_by_date(params[:date]))
  end

end
