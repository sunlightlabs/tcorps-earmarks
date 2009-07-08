namespace :data do  
  namespace :docs do
  
    DOCS_DIR = "#{RAILS_ROOT}/data/docs"
  
    desc "Create new SourceDoc entries for all the docs in the data/docs folder"
    task :load_into_db => :environment do
      puts "Loading each file in data/docs into the database."
      Dir.glob(File.join DOCS_DIR, '*').each do |path|
        source_file = File.basename path
        if SourceDoc.find_by_source_file(source_file)
          puts "  File #{source_file} is already in database, skipping."
        else
          source_doc = SourceDoc.create! :title => make_title(File.basename(source_file, File.extname(source_file))), :source_file => source_file
          puts "  Created SourceDoc for file #{source_file}."
        end
      end
    end
  
  end
end

def make_title(string)
  string.gsub '_', ' '
end