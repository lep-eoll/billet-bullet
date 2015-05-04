namespace :reports do
  require 'reporter'

  desc "Generate product reports"
  task :product => :environment do
    Reporter.new.product_report
  end
end
