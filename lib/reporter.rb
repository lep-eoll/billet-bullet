class Reporter

  def product_report(output_filename = "product_report_total_sales_to_#{Time.now.strftime('%m_%d')}.xls")
    book = Spreadsheet::Workbook.new
    Spree::Product.all.group_by {|product| product.name[0].upcase }.sort.each do |alpha_product|
      # ap "NEW SHEET #{alpha_product[0]} -----------------------------------------------------------------------------"
      sheet = book.create_worksheet(name: alpha_product[0])
      sheet_index = 1
      alpha_product[1].sort.each do |product|
        # ap product
        product_rows = process_product(product)
        product_rows_size = product_rows.size
        # ap "NEW PRODUCT ---------------------------"
        # ap "product_rows size is #{product_rows_size}, sheet_index #{sheet_index}"
        # ap "range to add: #{sheet_index..(sheet_index+product_rows_size)}"
        # ap "product rows:"
        # ap product_rows
        (sheet_index..(sheet_index + product_rows_size)).each do |row_num|
          row = product_rows.shift
          unless row.nil?
            sheet.row(row_num).default_format = event_title_format if row_num == sheet_index
            sheet.row(row_num).concat row
          end
        end
        sheet_index += (product_rows_size + 1)
      end
    end
    book.write output_filename
    puts "generated product report to: #{output_filename}"
    output_filename
  end

  def customer_order_report(output_filename = "order_report_total_sales_to_#{Time.now.strftime('%m_%d')}.xls")
    book = Spreadsheet::Workbook.new
    Spree::Order.includes(:bill_address).where(state: :complete).group_by {|order| order.billing_address.lastname.titleize[0]}.sort.each do |letter_group|
      sheet = book.create_worksheet(name: letter_group[0])
      sheet_index = 2
      sheet.row(0).concat ['Name', 'Order #', 'sku', 'quantity', 'price per ticket']
      letter_group[1].sort { |x,y| x.billing_address.last_name.titleize <=> y.billing_address.last_name.titleize }.each do |order|
        order_rows = process_order(order)
        order_rows_size = order_rows.size
        (sheet_index..(sheet_index + order_rows_size)).each do |row_num|
          row = order_rows.shift
          unless row.nil?
            sheet.row(row_num).default_format = event_title_format if row_num == sheet_index
            sheet.row(row_num).concat row
          end
        end
        sheet_index += (order_rows_size + 1)
      end
    end
    book.write output_filename
    puts "generated customer order report to: #{output_filename}"
    output_filename
  end

  def date_order_report(num_days_back = 14)
    output_filename = "orders_by_date_from_#{Date.current.strftime('%a_%b_%d')}_to_#{num_days_back.days.ago.strftime('%a_%b_%d')}.xls"
    book = Spreadsheet::Workbook.new
    Spree::Order.includes(:bill_address).where(["created_at > ?", num_days_back.days.ago]).where(state: :complete ).group_by {|order| order.updated_at.strftime('%y-%m-%d %a')}.sort.reverse.each do |date_string|
      sheet = book.create_worksheet(name: date_string[0])
      sheet_index = 2
      sheet.row(0).concat ['Name', 'Order #', 'sku', 'quantity', 'price per ticket']
      date_string[1].sort { |x,y| x.billing_address.last_name.titleize <=> y.billing_address.last_name.titleize }.each do |order|
        order_rows = process_order(order)
        order_rows_size = order_rows.size
        (sheet_index..(sheet_index + order_rows_size)).each do |row_num|
          row = order_rows.shift
          unless row.nil?
            sheet.row(row_num).default_format = event_title_format if row_num == sheet_index
            sheet.row(row_num).concat row
          end
        end
        sheet_index += (order_rows_size + 1)
      end
    end
    book.write output_filename
    puts "generated date order report to: #{output_filename}"
    output_filename
  end

  private

  def event_title_format
    @title ||= Spreadsheet::Format.new weight: :bold, size: 18
  end

  def process_order(order)
    order_rows = [[ "#{order.billing_address.last_name.titleize}, #{order.billing_address.first_name.titleize}","##{order.number}"]]
    order_rows << [order.email,  "#{order.billing_address.try(:city)} #{order.billing_address.try(:state).try(:abbr)}, #{order.billing_address.try(:country)}" ]
    order_rows << [order.created_at.strftime('%y %m %d')]
    order.line_items.each do |line_item|
      order_rows << ['', line_item.sku, line_item.quantity, "$#{line_item.price}" ]
    end
    order_rows
  end

  def process_product(product)
    product_rows = [[product.name]]
    total_admission = 0
    product.line_items.
      includes(:order).
      reject {|li| li.order.state != 'complete'}.
      group_by { |li| li.variant_id }.
      each do |variant_array|
        variant = Spree::Variant.find variant_array[0]
        variant_line_items = variant_array[1]
        variant_quantity = variant_line_items.inject(0) {|sum, li| sum + li.quantity}
        total_admission += variant_quantity

        product_rows << ['', "#{variant.sku} total",'', variant_quantity, '', 'price sold at', 'number tix']
        variant_line_items.group_by { |li| li.price }.sort.each do |priced_variants|
          product_rows << ['','','', '','', "$#{priced_variants[0]}", priced_variants[1].inject(0) {|sum, li| sum + li.quantity}]
        end
      end
      if is_goldcard_event?(product)
          product_rows << ['','Gold Card Admissions','', num_gold_cards]
          total_admission += num_gold_cards
      end
      product_rows << ['']
      product_rows << ['', 'TOTAL ADMISSION', '', total_admission]
    product_rows
  end

  def num_gold_cards
    @num_gold_cards ||= Spree::Product.find(11).line_items.
      includes(:order).
      reject {|li| li.order.state != 'complete'}.
      inject(0) {|sum, li| sum + li.quantity}
  end

  def is_goldcard_event?(product)
    [
       2, #Opening Gala
       19, #Unistus Chamber Choir
       20, #Youth guest performances
       21, #Colours, Sounds & Traditions of Estonia
       22, #National Opera of Estonia
       4, #Song Festival
       30, #Church Concert
       32, #Folk Dance celebration
       34 #Vanemuine Ballet Performance
    ].include? product.id
  end
end
