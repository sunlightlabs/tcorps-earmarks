# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  
  def clean_params(params, expected_keys)
    filtered_params = {}
    expected_keys.each do |key|
      filtered_params[key] = params[key]
    end
    filtered_params
  end
end