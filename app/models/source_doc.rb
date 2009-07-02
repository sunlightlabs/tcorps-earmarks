# A SourceDoc is an original, raw, source document.
class SourceDoc < ActiveRecord::Base

  has_many :letters
  belongs_to :legislator
  
  named_scope :converted, :conditions => {:conversion_failed => false}
  
  def plain_text=(raw)
    self.plain_text_length = (raw || "").length
    super raw
  end
  
  # Horribly un-performant
  def self.get_random
    # if this gets un-performant, it should be refactored to be one
    # SourceDoc query that joins against Legislator on done=false
    source_docs = Legislator.not_done.all.map {|legislator| legislator.source_docs.converted.all}.flatten
    
    min = source_docs.min {|x, y| x.letters_count <=> y.letters_count}.letters_count
    
    most_needed = source_docs.select {|source_doc| source_doc.letters_count == min}
    most_needed[rand most_needed.length]
  end
  
end