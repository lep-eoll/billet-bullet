module Spree
  module LepProductsHelper
    def each_date_bucket(&block)
      buckets = @products.group_by do |product|
        product.property 'Date'
      end
      bucket_names = buckets.keys.compact.sort

      registration_section = bucket_names.delete 'pre-festival'

      yield 'Registreerimine - Registration', buckets['pre-festival'] if registration_section.present?

      bucket_names.each {|name| yield name_to_title(name), sort_date_bucket(buckets[name]) if block_given?}

      yield 'No date', buckets[nil] if buckets[nil] && block_given?
    end

    def lep_property_name(name)
       case name
       when 'Venue'
         'Koht / Venue'
       when 'Date'
         'Kuupäev / Date'
       when 'Time'
         'Aeg / Time'
       else
         name
       end
    end

    private
    def name_to_title(date_string)
      case date_string.split('-').last
      when '04'
        'Aug 4 - Teisipäev / Tuesday'
      when '05'
        'Aug 5 - Kolmapäev / Wednesday'
      when '06'
        'Aug 6 - Neljapäev / Thursday'
      when '07'
        'Aug 7 - Reede / Friday'
      when '08'
        'Aug 8 - Laupäev / Saturday'
      when '09'
        'Aug 9 - Pühapäev / Sunday'
      when '10'
        'Aug 10 - Esmaspäev / Monday'
      when '11'
        'Aug 11 - Teisipäev / Tuesday'
      end
    end

    def sort_date_bucket(events)
      events.sort {|a,b| date_to_i(a.property 'Time') <=> date_to_i(b.property 'Time')}
    end

    def date_to_i(date_string)
      date_string ? date_string.gsub(':','').to_i : 0
    end
  end
end
