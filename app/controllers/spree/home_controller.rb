module Spree
  class HomeController < Spree::StoreController
    helper 'spree/products'
    respond_to :html

    def index
      @searcher = build_searcher (params.merge(include_properties: true))
      @products = @searcher.retrieve_products
    end
  end
end
