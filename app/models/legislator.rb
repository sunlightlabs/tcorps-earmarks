class Legislator < ActiveRecord::Base
  has_many :source_docs
  
  named_scope :alphabetical, :order => 'name asc'
end