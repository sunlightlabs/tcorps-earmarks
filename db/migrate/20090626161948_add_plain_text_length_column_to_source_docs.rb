class AddPlainTextLengthColumnToSourceDocs < ActiveRecord::Migration
  
  def self.up
    add_column :source_docs, :plain_text_length, :integer
    add_index :source_docs, :plain_text_length
    
    SourceDoc.all.each do |source_doc|
      plain_text = source_doc.plain_text || ""
      source_doc.update_attribute(:plain_text_length, plain_text.length)
    end
  end

  def self.down
    remove_index :source_docs, :plain_text_length
    remove_column :source_docs, :plain_text_length
  end
  
end
