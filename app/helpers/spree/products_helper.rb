module Spree
  module ProductsHelper
    def each_date_bucket(&block)
      buckets = @products.group_by do |product|
        product.property 'Date'
      end
      bucket_names = buckets.keys.compact.sort

      bucket_names.each {|name| yield name, buckets[name] if block_given?}
      yield 'No date', buckets[nil] if buckets[nil] && block_given?
    end
  end
end
