class ChangeLegislatorIdColumnToInteger < ActiveRecord::Migration
  def self.up
    remove_column :earmarks, :legislator_id
    add_column :earmarks, :legislator_id, :integer
    add_index :earmarks, :legislator_id
    # while we're at it
    add_index :earmarks, :document_id
  end

  def self.down
    remove_index :earmarks, :document_id
    
    remove_index :earmarks, :legislator_id
    remove_column :earmarks, :legislator_id
    add_column :earmarks, :legislator_id, :string
  end
end