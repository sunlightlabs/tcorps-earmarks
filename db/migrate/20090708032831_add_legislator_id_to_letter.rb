class AddLegislatorIdToLetter < ActiveRecord::Migration
  def self.up
    add_column :letters, :legislator_id, :integer
    add_index :letters, :legislator_id
  end

  def self.down
    remove_index :letters, :legislator_id
    remove_column :letters, :legislator_id
  end
end
