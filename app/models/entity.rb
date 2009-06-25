class Entity < ActiveRecord::Base
  
  belongs_to :letter
  
  validates_presence_of :name
  validates_presence_of :address
  
end
