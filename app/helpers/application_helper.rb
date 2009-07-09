# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tcorps_url
    APP_CONFIG['tcorps_url']
  end
  
  def another_task_img_tag
    src = URI.join(APP_CONFIG['tcorps_url'], '/images/btn_anotherTask.png').to_s
    image_tag(src, :alt => %{This is what the "I'd Like Another Task" button looks like.})
  end
  
  # Removes zero cents (the .00 part) if present.
  # Otherwise, returns entire part.
  def as_currency(item)
    naive = number_to_currency(item)
    if naive =~ /^([$]?[\d,]*).00$/
      $1
    else
      naive
    end
  end
  
  def legislators_for_select
    Legislator.alphabetical.all.map {|legislator| [reordered_name(legislator.name), legislator.id]}.sort {|x, y| x[0] <=> y[0]}
  end
  
  def reordered_name(name)
    names = name.split
    last = names.pop
    "#{last}, #{names.join ' '}"
  end

end
