class AddDoneFlagToLegislator < ActiveRecord::Migration
  def self.up
    add_column :legislators, :done, :boolean, :default => false
    add_index :legislators, :done
  end

  def self.down
    remove_index :legislators, :done
    remove_column :legislators, :done
  end
end