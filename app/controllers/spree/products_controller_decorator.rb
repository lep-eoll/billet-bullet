Spree::ProductsController.class_eval do
  before_action :new_event_registration, only: :show

  def index
    redirect_to root_url
  end

  private

  def new_event_registration
    @event_registration = EventRegistration.new
  end
end
