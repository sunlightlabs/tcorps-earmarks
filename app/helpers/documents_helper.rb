module DocumentsHelper
  def as_currency(item)
    naive = number_to_currency(item)
    naive =~ /^([$]?[\d,]*).00$/ ? $1 : naive
  end
  
  def legislators_for_select
    Legislator.all.map {|legislator| [reordered_name(legislator.name), legislator.id]}.sort {|x, y| x[0] <=> y[0]}
  end
  
  def reordered_name(name)
    names = name.split
    last = names.pop
    "#{last}, #{names.join ' '}"
  end
end