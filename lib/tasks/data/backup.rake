namespace :data do

  namespace :backup do
    
    desc "Backup Legislator and Document databases to YAML."
    task :all => [:legislator, :document]
  
    desc "Backup Legislator database to YAML."
    task :legislator => :environment do
      backup_model Legislator
    end

    desc "Backup Document database to YAML."
    task :document => :environment do
      backup_model Document
    end
  
    def backup_model(model)
      filename = construct_filename(model.table_name)
      puts "Backing up #{model} data to #{filename}."
      data = load_model_into_memory model
      save_as_yaml filename, data
    end
  
    def load_model_into_memory(model)
      model.all.reduce([]) do |records, record|
        element = {}
        model.columns.map(&:name).each do |field|
          element[field] = record[field]
        end
        records << element
      end
    end
  
    def save_as_yaml(filename, data)
      puts "  Saving results to %s" % filename
      FileUtils.mkdir_p File.dirname(filename)
      File.open(filename, "w") do |file|
        YAML.dump data, file
      end
    end
    
    def self.construct_filename(filename)
      "%s.yml" % File.join("#{RAILS_ROOT}/data/backup", filename)
    end

  end

end