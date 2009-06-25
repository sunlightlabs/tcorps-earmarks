# Here we monkey patch the Oniguruma gem.
class MatchData
  
  def named_captures
    captures = {}
    @named_captures.each do |capture|
      name = capture[0].to_sym
      captures[name] = self[name]
    end
    captures
  end

end
