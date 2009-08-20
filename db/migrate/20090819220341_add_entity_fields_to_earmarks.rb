class AddEntityFieldsToEarmarks < ActiveRecord::Migration
  def self.up
    add_column :earmarks, :entities, :string
    add_column :earmarks, :entities_certainty, :decimal
  end

  def self.down
    remove_column :earmarks, :entities_certainty
    remove_column :earmarks, :entities
  end
end