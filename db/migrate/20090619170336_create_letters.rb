class CreateLetters < ActiveRecord::Migration
  def self.up
    create_table :letters do |t|
      t.decimal :amount
      t.string  :project_title
      t.integer :fiscal_year
      t.text    :funding_purpose
      t.text    :taxpayer_justification
      t.integer :user_id
      t.integer :source_doc_id
      t.string  :task_key
      t.timestamps
    end

    add_index :letters, :amount
    add_index :letters, :fiscal_year
    add_index :letters, :user_id
    add_index :letters, :source_doc_id
  end

  def self.down
    drop_table :letters
  end
end
