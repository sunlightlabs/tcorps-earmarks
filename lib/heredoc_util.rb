class HeredocUtil

  def self.prettify(string)
    string.lines.map { |x| x.lstrip.chomp }.join("\n")
  end
  
end
