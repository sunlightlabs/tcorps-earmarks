class RemovePlainTextLengthFromSourceDocs < ActiveRecord::Migration
  def self.up
    remove_index :source_docs, :plain_text_length
    remove_column :source_docs, :plain_text_length
  end

  def self.down
    add_column :source_docs, :plain_text_length, :integer
    add_index :source_docs, :plain_text_length
  end
end