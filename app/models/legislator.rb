class Legislator < ActiveRecord::Base
  has_many :documents
  
  named_scope :alphabetical, :order => 'name asc'
end