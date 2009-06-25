class TcorpsUtil
  
  def self.signal_task_completion(task_key)
    url = URI.join(APP_CONFIG['tcorps_url'], '/tasks/complete')
    Rails.logger.info "== Signaling task completion by POSTing to #{url}..."
    response = Net::HTTP.post_form(url, :task_key => task_key)
    Rails.logger.info "   Response : #{response.to_yaml}"
  end

  # In the future, we may add this to the method above:
  # rescue Errno::ECONNREFUSED
  #   false
  #
  # For now, I want to know about any errors that might occur.

end
