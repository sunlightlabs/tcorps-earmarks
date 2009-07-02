class Legislator < ActiveRecord::Base

  has_many :source_docs

  named_scope :done, :conditions => {:done => true}
  named_scope :not_done, :conditions => {:done => false}

end