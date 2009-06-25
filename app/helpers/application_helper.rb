# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Removes the .00 part if present.
  # Otherwise, returns entire part.
  def as_currency(item)
    naive = number_to_currency(item)
    if naive =~ /^([$]?[\d,]*).00$/
      $1
    else
      naive
    end
  end

end
