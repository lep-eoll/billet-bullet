class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :authenticate_beta_environments

  def authenticate_beta_environments
    if ENV['HTTP_BASIC_PASSWORD'].present?
      authenticate_or_request_with_http_basic(realm = "LEP2015 Ecommerce Site (BETA)") do |username, password|
        username == ENV['HTTP_BASIC_PASSWORD'] && password == ENV['HTTP_BASIC_PASSWORD']
      end
    end
  end

end
