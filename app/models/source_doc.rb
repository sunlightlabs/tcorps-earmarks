# A SourceDoc is an original, raw, source document.
class SourceDoc < ActiveRecord::Base
  
  has_many :letters
  belongs_to :legislator
  
end
