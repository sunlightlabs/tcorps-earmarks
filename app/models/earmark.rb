class Earmark < ActiveRecord::Base
  belongs_to :document
  validates_presence_of :project_title, :legislator_id, :funding_purpose
end