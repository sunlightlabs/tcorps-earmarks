require 'open-uri'

namespace :data do
  
  namespace :directory do
    
    LEGISLATOR_URLS = "#{RAILS_ROOT}/data/earmark_letter_sources.yml"
    LETTER_URLS_DIR = "#{RAILS_ROOT}/data/generated"
    
    # Note: the "fetch" and "load_into_db" tasks are highly coupled!
    
    desc "Fetch earmark request letter URLs and save to YAML."
    task :fetch => :environment do
      puts "Loading list of URLs where we can find earmark request letters."
      legislators = YAML::load_file(LEGISLATOR_URLS)
      puts "Found #{legislators.length} URLs."

      legislators.each do |legislator_name, hash|
        puts "  -- %s --" % legislator_name
        url = hash["url"]
        css_rule = hash["css_rule"]

        puts "    Getting #{url}."
        doc = Nokogiri::HTML(open(URI.encode(url)))
        puts "    Parsing using '%s'" % css_rule
        nodes = doc.css(css_rule)
        puts "    Found #{nodes.length} matches."

        letters = []
        nodes.each do |node|
          letters << {
            "href"    => URI.join(url, simple_encode(node["href"])).to_s,
            "content" => simple_cleanse(node.content)
          }
        end

        out_filename = "%s.yml" % File.join(LETTER_URLS_DIR, legislator_name)
        puts "    Saving results to %s" % out_filename
        FileUtils.mkdir_p(LETTER_URLS_DIR)
        File.open(out_filename, "w") do |outfile|
          YAML.dump({ legislator_name => letters }, outfile)
        end
      end
      puts "Done fetching earmark request letters."
    end

    desc "Populate database using YAML file(s)."
    task :load_into_db => :environment do
      filenames = Dir.glob(File.join(LETTER_URLS_DIR, "*.yml"))
      puts "Populating #{SourceDoc.table_name} with Earmark Request Letter info."
      puts "Will read from #{filenames.length} files."
      filenames.each do |filename|
        puts "  Reading file named #{filename}"
        data = YAML::load_file(filename)
        data.each do |legislator_name, letters|
          if legislator = Legislator.find_by_name(legislator_name)
            puts "    Found existing legislator named #{legislator_name}."
          else
            puts "    Creating Legislator named #{legislator_name}."
            legislator = Legislator.create! :name => legislator_name
          end
          
          puts "    Writing letters to #{SourceDoc.table_name}."
          letters.each do |letter|
            source_doc = SourceDoc.find_or_create_by_source_url letter['href']
            source_doc.attributes = {
              :title => make_title(letter['content']),
              :legislator => legislator
            }
            source_doc.save!
          end
        end
      end
      puts "Done loading data into #{SourceDoc.table_name}."
    end

  end
  
  def simple_encode(string)
    string.gsub ' ', '%20'
  end
  
  def simple_cleanse(string)
    string.gsub /\r?\n\s*/, ' '
  end
  
end