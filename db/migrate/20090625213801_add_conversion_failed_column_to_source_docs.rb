class AddConversionFailedColumnToSourceDocs < ActiveRecord::Migration
  
  def self.up
    add_column :source_docs, :conversion_failed, :boolean, :default => false
    add_index :source_docs, :conversion_failed
  end

  def self.down
    remove_column :source_docs, :conversion_failed
    remove_index :source_docs, :conversion_failed
  end
  
end
