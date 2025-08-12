# Apartment Configuration for Rails 7.1
# Using ros-apartment gem (Rails 7+ compatible fork)  
# https://github.com/rails-on-services/apartment

# Temporarily disable apartment to test MySQL connection first
# require 'apartment/elevators/subdomain'

# Apartment.configure do |config|
#   # Use database names instead of schemas (for MySQL)
#   config.use_schemas = false
#   
#   # Models that should remain in the public/default database
#   config.excluded_models = %w[Company User]
#   
#   # Function to get tenant names (we'll implement this later)
#   # config.tenant_names = lambda { Company.pluck(:subdomain) }
# end

# Configure subdomain-based tenant switching middleware
# Rails.application.config.middleware.use Apartment::Elevators::Subdomain