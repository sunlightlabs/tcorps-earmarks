namespace :data do

  namespace :restore do

    desc "Restore (destructively) Legislator and SourceDoc databases using YAML backup"
    task :all => [:legislator, :source_doc]

    desc "Restore (destructively) Legislator database using YAML backup"
    task :legislator => :environment do
      restore_model(Legislator, DataBackupHelper::LEGISLATOR_FIELDS)
    end

    desc "Restore (destructively) SourceDoc database using YAML backup"
    task :source_doc => :environment do
      restore_model(SourceDoc, DataBackupHelper::SOURCE_DOC_FIELDS)
    end
  
    def restore_model(model, fields)
      model.delete_all
      filename = DataBackupHelper.construct_filename(model.table_name)
      puts "Restoring #{model} data from #{filename}."
      data = load_yaml_into_memory(filename)
      load_into_database(data, model, fields)
    end

    def load_yaml_into_memory(filename)
      YAML::load_file(filename)
    end

    def load_into_database(data, model, fields)
      data.each do |data_row|
        record = model.new
        fields.each do |field|
          record[field] = data_row[field] if data_row[field]
        end
        record.save
      end
    end

  end

end
