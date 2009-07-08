# A SourceDoc is an original, raw, source document.
class SourceDoc < ActiveRecord::Base

  has_many :letters
  belongs_to :legislator
  
  named_scope :converted, :conditions => {:conversion_failed => false}
  
  named_scope :done, :conditions => {:done => true}
  named_scope :not_done, :conditions => {:done => false}
  
  def plain_text=(raw)
    self.plain_text_length = (raw || "").length
    super raw
  end
  
  # pulls the least checked 30, finds the ones that tie for the absolutely least checked,
  # and chooses a random one of those
  def self.get_random
    source_docs = SourceDoc.not_done.converted.all :order => 'letters_count ASC', :limit => 30
    
    min = source_docs.min {|x, y| x.letters_count <=> y.letters_count}.letters_count
    
    most_needed = source_docs.select {|source_doc| source_doc.letters_count == min}
    most_needed[rand most_needed.length]
  end
  
end