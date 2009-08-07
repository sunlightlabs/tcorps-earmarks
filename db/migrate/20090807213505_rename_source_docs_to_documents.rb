class RenameSourceDocsToDocuments < ActiveRecord::Migration
  def self.up
    rename_table :source_docs, :documents
    rename_column :letters, :source_doc_id, :document_id
  end

  def self.down
    rename_column :letters, :document_id, :source_doc_id
    rename_table :documents, :source_docs
  end
end