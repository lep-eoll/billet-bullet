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


    private
    def name_to_title(date_string)
      case date_string.split('-').last
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
      end
    end

    def sort_date_bucket(events)
      events.sort {|a,b| a.property('Time') <=> b.property('Time')}
    end

  end
end
