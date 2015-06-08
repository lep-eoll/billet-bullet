namespace :reports do
  require 'reporter'
  require 'zip'

  desc "Generate order report by product"
  task :product => :environment do
    Reporter.new.product_report
  end

  desc "Generate order report by client last name"
  task :client_order => :environment do
    Reporter.new.customer_order_report
  end

  desc "Generate order report by date"
  task :date_order => :environment do
    Reporter.new.date_order_report 14
  end

  desc "Generate all the reports and send them via email"
  task :all_reports_zipped => :environment do
    Dir["*.zip","*.xls"].each {|filename| File.delete filename }
    Reporter.new.product_report
    Reporter.new.customer_order_report
    Reporter.new.date_order_report 14

    zipfile_name = "LEP_Sales_Reports_#{Time.current.strftime('%a_%b_%d')}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Dir["*.xls"].each do |filename|
        zipfile.add( "LEP Sales Reports #{Time.current.strftime('%a %b %d')}/#{filename}", filename)
      end
    end

    ReportMailer.daily_report(zipfile_name)

  end
end
