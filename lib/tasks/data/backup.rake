namespace :data do

  namespace :backup do
    
    desc "Backup Legislator and SourceDoc databases to YAML."
    task :all => [:legislator, :source_doc]
  
    desc "Backup Legislator database to YAML."
    task :legislator => :environment do
      backup_model(Legislator, DataBackupHelper::LEGISLATOR_FIELDS)
    end

    desc "Backup SourceDoc database to YAML."
    task :source_doc => :environment do
      backup_model(SourceDoc, DataBackupHelper::SOURCE_DOC_FIELDS)
    end
  
    def backup_model(model, fields)
      filename = DataBackupHelper.construct_filename(model.table_name)
      puts "Backing up #{model} data to #{filename}."
      data = load_model_into_memory(model, fields)
      save_as_yaml(filename, data)
    end
  
    def load_model_into_memory(model, fields)
      model.all.reduce([]) do |records, record|
        element = {}
        fields.each do |field|
          element[field] = record[field]
        end
        records << element
      end
    end
  
    def save_as_yaml(filename, data)
      puts "  Saving results to %s" % filename
      FileUtils.mkdir_p(File.dirname(filename))
      File.open(filename, "w") do |file|
        YAML.dump(data, file)
      end
    end

  end

end
