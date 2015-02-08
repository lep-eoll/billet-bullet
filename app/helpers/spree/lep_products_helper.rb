module Spree
  module LepProductsHelper
    def each_date_bucket(&block)
      buckets = @products.group_by do |product|
        product.property 'Date'
      end
      bucket_names = buckets.keys.compact.sort

      registration_section = bucket_names.delete 'pre-festival'

      yield 'Registreerimine - Registration', buckets['pre-festival'] if registration_section.present?

      bucket_names.each {|name| yield name, buckets[name] if block_given?}

      yield 'No date', buckets[nil] if buckets[nil] && block_given?
    end
  end
end
