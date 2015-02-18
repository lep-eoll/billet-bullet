Spree::ProductsController.class_eval do
  def index
    redirect_to root_url
  end
end
