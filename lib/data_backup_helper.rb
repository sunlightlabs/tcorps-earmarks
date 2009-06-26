class DataBackupHelper

  BACKUP_DIR = "#{RAILS_ROOT}/data/backup"

  LEGISLATOR_FIELDS = %w(
    id
    name
    created_at
    updated_at
  )
  
  # Intentionally not included:
  # * line_items_count
  #   why? --> it is automatically generated by Rails
  #
  # * plain_text_length
  #   why --> it is automatically generated by SourceDoc#plain_text=
  #
  SOURCE_DOC_FIELDS = %w(
    id
    title
    source_url
    source_file
    scribd_doc_id
    legislator_id
    created_at
    updated_at
    access_key
    plain_text
    created_at
    updated_at
    conversion_failed
  )
  
  def self.construct_filename(filename)
    "%s.yml" % File.join(BACKUP_DIR, filename)
  end
  
end
