class TcorpsUtil
  
  def self.signal_task_completion(task_key, new_task = false)
    url = URI.join(APP_CONFIG['tcorps_url'], '/tasks/complete')
    Rails.logger.info "== Signaling task completion by POSTing to #{url}..."
    
    params = {:task_key => task_key}
    if new_task
      params[:new_task] = 1
      Rails.logger.info "== Requesting new task right away..."
    end
    
    response = Net::HTTP.post_form(url, params)
    Rails.logger.info "   Response : #{response.to_yaml}"
    
    response
  rescue Errno::ECONNREFUSED
    false
  end
  
end