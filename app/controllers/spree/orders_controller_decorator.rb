Spree::OrdersController.class_eval do
  def populate
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(params[:variant_id], params[:quantity], params[:options]) && populate_event_registration
      respond_with(@order) do |format|
        format.html { redirect_to cart_path }
      end
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_back_or_default(spree.root_path)
    end
  end

  private

  def populate_event_registration
    line_item = current_order.line_items.find_by(variant_id: params[:variant_id])
    params[:quantity].to_i.times.map do
      line_item.event_registrations << EventRegistration.create!(event_registration_params)
    end.all?
  rescue ActionController::ParameterMissing
    true
  end

  def event_registration_params
    params.require(:event_registration).permit(:name)
  end
end
