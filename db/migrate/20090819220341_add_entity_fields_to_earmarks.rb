class AddEntityFieldsToEarmarks < ActiveRecord::Migration
  def self.up
    add_column :earmarks, :entity_names, :string
    add_column :earmarks, :entity_names_certainty, :decimal
    add_column :earmarks, :entity_addresses, :string
    add_column :earmarks, :entity_addresses_certainty, :decimal
  end

  def self.down
    remove_column :earmarks, :entity_addresses_certainty
    remove_column :earmarks, :entity_addresses
    remove_column :earmarks, :entity_names_certainty
    remove_column :earmarks, :entity_names
  end
end