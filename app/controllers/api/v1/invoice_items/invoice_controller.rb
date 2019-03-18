class Api::V1::InvoiceItems::InvoiceController < ApplicationController

  def show
    render json: InvoiceSerializer.new(InvoiceItem.find(params["invoice_item_id"]).invoice)
  end

end
