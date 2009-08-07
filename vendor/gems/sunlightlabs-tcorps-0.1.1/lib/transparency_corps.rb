require 'open-uri'
require 'net/http'

class TransparencyCorps

  @@url = 'http://transparencycorps.org'
  COMPLETE_PATH = '/tasks/complete'
  NEW_TASK_PARAMS = {:new_task => 1}
  
  def self.url=(url)
    @@url = url
  end
  
  def self.url
    @@url
  end
  
  def self.complete_task_and_reassign(task_key)
    response = complete_task task_key, true
    if response.body and response.body.strip.any?
      response.body
    else
      false
    end
  end
  
  def self.complete_task(task_key, reassign = false)
    params = {:task_key => task_key}
    params.merge! NEW_TASK_PARAMS if reassign
    Net::HTTP.post_form URI.join(url, COMPLETE_PATH), params
  end

end