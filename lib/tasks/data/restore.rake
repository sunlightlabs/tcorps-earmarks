namespace :data do

  namespace :restore do

    desc "Restore (destructively) Legislator and Document databases using YAML backup"
    task :all => [:legislator, :document]

    desc "Restore (destructively) Legislator database using YAML backup"
    task :legislator => :environment do
      restore_model Legislator
    end

    desc "Restore (destructively) Document database using YAML backup"
    task :document => :environment do
      restore_model Document
    end
  
    def restore_model(model)
      model.delete_all
      filename = construct_filename(model.table_name)
      puts "Restoring #{model} data from #{filename}."
      data = load_yaml_into_memory(filename)
      load_into_database data, model
    end

    def load_yaml_into_memory(filename)
      YAML::load_file(filename)
    end

    def load_into_database(data, model)
      data.each do |data_row|
        record = model.new
        data_row.keys.each do |field|
          record[field] = data_row[field] if data_row[field]
        end
        record.save
      end
    end
    
    def self.construct_filename(filename)
      "%s.yml" % File.join("#{RAILS_ROOT}/data/backup", filename)
    end

  end

end