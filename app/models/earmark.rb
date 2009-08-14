class Earmark < ActiveRecord::Base
  validates_presence_of :project_title, :legislator_id, :funding_purpose
end