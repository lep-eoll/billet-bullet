<img src='http://lep2015.com/wp-content/uploads/2014/06/cropped-LEP2015-Banner-White-Web-525wide.png' alt="lep2015 logo"/>
<table>
  <tr>
    <td>
      <p class="lede">
        Dear <%= @order.user.bill_address.firstname + ' ' + @order.user.bill_address.lastname %>,
      </p>
      <p>
      The countdown to LEP 2015 is on!
      </p>
      <p>
      Please note that this email is NOT your ticket. See *Delivery* below for details on where to pick up your ticket.
      Thank you for using LEP 2015 online ticketing system. This email confirms your purchase and receipt of your payment. Please save this receipt for your records
      </p>
      <p>
       Here are the details of your order:
      </p>
      <table>
        <% @order.line_items.each do |item| %>
          <tr>
            <td><%= item.variant.sku %></td>
            <td>
              <%= raw(item.variant.product.name) %>
            </td>
            <td>(<%=item.quantity%>) @ <%= item.single_money %> = <%= item.display_amount %></td>
          </tr>
        <% end %>
        <tr>
          <td></td>
          <td>
            <%= Spree.t('order_mailer.confirm_email.subtotal') %>
          </td>
          <td>
            <%= @order.display_item_total %>
          </td>
        </tr>
        <% if @order.line_item_adjustments.exists? %>
          <% if @order.all_adjustments.promotion.eligible.exists? %>
            <% @order.all_adjustments.promotion.eligible.group_by(&:label).each do |label, adjustments| %>
              <tr>
                <td></td>
                <td><%= Spree.t(:promotion) %> <%= label %>:</td>
                <td><%= Spree::Money.new(adjustments.sum(&:amount), currency: @order.currency) %></td>
              </tr>
            <% end %>
          <% end %>
        <% end %>
        <% @order.shipments.group_by { |s| s.selected_shipping_rate.try(:name) }.each do |name, shipments| %>
          <tr>
            <td></td>
            <td><%= Spree.t(:shipping) %> <%= name %>:</td>
            <td><%= Spree::Money.new(shipments.sum(&:discounted_cost), currency: @order.currency) %></td>
          </tr>
        <% end %>
        <% if @order.all_adjustments.eligible.tax.exists? %>
          <% @order.all_adjustments.eligible.tax.group_by(&:label).each do |label, adjustments| %>
            <tr>
              <td></td>
              <td><%= Spree.t(:tax) %> <%= label %>:</td>
              <td><%= Spree::Money.new(adjustments.sum(&:amount), currency: @order.currency) %></td>
            </tr>
          <% end %>
        <% end %>
        <% @order.adjustments.eligible.each do |adjustment| %>
          <% next if (adjustment.source_type == 'Spree::TaxRate') and (adjustment.amount == 0) %>
          <tr>
            <td></td>
            <td><%= adjustment.label %>:</td>
            <td><%= adjustment.display_amount %></td>
          </tr>
        <% end %>
        <tr>
          <td></td>
          <td>
            <%= Spree.t('order_mailer.confirm_email.total') %>
          </td>
          <td>
            <%= @order.display_total %>
          </td>
        </tr>
      </table>
      <p> Delivery of Tickets</p>
      <p>
      Purchased tickets will be available for pickup at the Festival registration area in the Hilton Hotel from Aug 4th - 8th, 2015. Please ensure you pick up your tickets at least 1 hour prior to the start of the performance. Tickets are non-refundable and have no cash value. Should you have any questions about your purchase, please email info@lep2015.com.<br/>
      We look forward to seeing you in Whistler next summer as we celebrate Estonia on the West Coast.
      </p>
    <p>
      Regards,<br/>
      The LEP 2015 Vancouver/Whistler Organizing Committee
    </p>
    </td>
    <td class="expander"></td>
  </tr>
</table>
