class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.integer :letter_id
      t.string  :name
      t.string  :address
      t.timestamps
    end

    add_index :entities, :letter_id
  end

  def self.down
    drop_table :entities
  end
end
