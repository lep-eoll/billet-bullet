class Reporter

  def product_report(output_filename = 'product_report.xls')
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
        sheet_index += (product_rows_size +1)
      end
    end
    book.write output_filename
  end

  def order_report(output_filename = 'order_report.xls')

  end

  private

  def event_title_format
    @title ||= Spreadsheet::Format.new weight: :bold, size: 18
  end

  def process_product(product)
    product_rows = [[product.name]]
    product.line_items.group_by { |li| li.variant_id }.each do |variant_array|
      variant = Spree::Variant.find variant_array[0]
      variant_line_items = variant_array[1]
      # puts "Variant '#{variant.sku}' Total sold : #{variant_line_items.size}"
      product_rows << ['', "#{variant.sku} total",'', variant_line_items.size, '', 'price sold at', 'number tix']
      costs = variant_line_items.group_by { |li| li.price }.sort.each do |priced_variants|
        product_rows << ['','','', '','', "$#{priced_variants[0]}", priced_variants[1].size]
        # puts "sold at $#{priced_variants[0]}' Total sold : #{priced_variants[1].size}"
      end
      product_rows << ['']
    end
    product_rows
  end

end
