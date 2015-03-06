# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'


Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
  config.products_per_page = 500
  config.logo = 'cropped-LEP2015-Banner-White-Web-525wide.png'
  config.show_variant_full_price = true
  config.mails_from = 'tickets@lep2015.com'
end

Spree.user_class = "Spree::User"

