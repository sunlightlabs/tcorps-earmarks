class SortingHat
  
  # Returns a SourceDoc instance
  def self.get_source_doc
    min = SourceDoc.minimum(:letters_count)
    letters = SourceDoc.find_all_by_letters_count(min)
    SourceDoc.find(rand(letters.length))
  end
  
end