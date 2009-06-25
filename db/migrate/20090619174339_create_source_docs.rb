class CreateSourceDocs < ActiveRecord::Migration
  def self.up
    create_table :source_docs do |t|
      t.string  :title
      t.string  :source_url
      t.string  :source_file
      t.integer :scribd_doc_id
      t.string  :access_key
      t.text    :plain_text
      t.integer :legislator_id
      t.integer :letters_count, :default => 0
      t.timestamps
    end

    add_index :source_docs, :legislator_id
    add_index :source_docs, :scribd_doc_id
    add_index :source_docs, :letters_count
  end

  def self.down
    drop_table :source_docs
  end
end
