class Api::V1::InvoiceItems::SearchController < ApplicationController

  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.where(invoice_item_params))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(invoice_item_params))
  end

  private

  def invoice_item_params
    if params[:unit_price] && params[:unit_price].include?('.')
      params[:unit_price] = params[:unit_price].delete!('.')
    end
    params.permit(:id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at)
  end

end
