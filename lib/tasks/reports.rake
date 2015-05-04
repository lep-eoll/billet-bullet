namespace :reports do
  require 'reporter'

  desc "Generate product reports"
  task :product => :environment do
    Reporter.new.product_report
  end

  desc "Generate Order report (client last name)"
  task :order => :environment do
    Reporter.new.order_report
  end

end
