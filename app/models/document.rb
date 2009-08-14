# A SourceDoc is an original, raw, source document.
class Document < ActiveRecord::Base

  has_many :letters
  belongs_to :legislator
  
  named_scope :converted, :conditions => {:conversion_failed => false}
  named_scope :not_converted, :conditions => {:conversion_failed => true}
  
  named_scope :done, :conditions => {:done => true}
  named_scope :not_done, :conditions => {:done => false}
  
  # pulls the least checked 30, finds the ones that tie for the absolutely least checked,
  # and chooses a random one of those
  def self.next
    documents = self.not_done.converted.all :order => 'letters_count ASC', :limit => 30
    
    min = documents.min {|x, y| x.letters_count <=> y.letters_count}.letters_count
    
    most_needed = documents.select {|document| document.letters_count == min}
    most_needed[rand most_needed.length]
  end
  
end