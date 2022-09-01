class PurchasesController < ApplicationController

  TOP_PRODUCTS = 3

  def index
    # Review: Mejor si se hubiése implementado strong_params.
    @purchases = Query::PurchaseFilter.call(params)
  end

  def top_sellings
    render json: Query::PurchaseRanking.new(TOP_PRODUCTS).run
  end
end
