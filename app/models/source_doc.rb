# A SourceDoc is an original, raw, source document.
class SourceDoc < ActiveRecord::Base
  
  has_many :letters
  belongs_to :legislator
  
  def self.get_random
    min = self.minimum(:letters_count)
    letters = self.find(:all, :conditions =>
      ["letters_count = ? and conversion_failed = ?", min, false])
    letters[rand(letters.length)]
  end
  
end
