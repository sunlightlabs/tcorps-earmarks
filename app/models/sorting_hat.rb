class SortingHat
  
  # Returns a SourceDoc
  def self.get_source_doc
    min = SourceDoc.minimum(:letters_count)
    SourceDoc.find_by_letters_count(min)
  end
  
end