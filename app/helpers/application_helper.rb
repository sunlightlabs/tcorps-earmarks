# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def scribd_url(doc_id)
    "http://www.scribd.com/doc/#{doc_id}"
  end

end
