class AddBioguideIdToLegislator < ActiveRecord::Migration

  def self.up
    add_column :legislators, :bioguide_id, :string
    add_index :legislators, :bioguide_id
  end

  def self.down
    remove_column :legislators, :bioguide_id
  end
  
end