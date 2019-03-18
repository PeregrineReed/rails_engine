class Api::V1::Invoices::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.where_invoice(params["invoice_id"]))
  end

end
