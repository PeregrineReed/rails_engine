class Api::V1::InvoiceItems::ItemController < ApplicationController

  def show
    render json: ItemSerializer.new(InvoiceItem.find(params["invoice_item_id"]).item)
  end

end
