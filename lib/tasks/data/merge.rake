require 'text'

namespace :merge do

  MERGE_DIR = "#{RAILS_ROOT}/data/merged"

  desc "Produce YAML file of letter analysis of Documents"
  task :responses => :environment do    
    letters = {}
    Document.all.each do |document|
      letter = {}
      letter[:responses] = document.letters_count
      letter[:scribd_url] = "http://www.scribd.com/doc/#{document.scribd_doc_id}/"
      [:amount, :project_title, :funding_purpose, :legislator_id].each do |field|
        letter[field], letter["#{field}_matches".to_sym] = best document.letters.map(&field)
      end
      if letter[:legislator_id] and legislator = Legislator.find_by_id(letter[:legislator_id])
        letter[:legislator_name] = legislator.name
        letter[:legislator_bioguide_id] = legislator.bioguide_id
        letter.delete :legislator_id
      end
      letters["document_#{document.id}".to_sym] = letter
    end
    puts "  Saving #{letters.keys.size} merged responses to responses.yml."
    save_as_yaml File.join(MERGE_DIR, 'responses.yml'), letters
  end
  

  def best(strings, distance = 0)
    choices = matches(strings, distance)
    choices.first || [strings.first, 1]
  end
  
  def matches(strings, distance = 0)
    match = if distance == 0
      lambda {|x, y| x == y}
    else
      lambda {|x, y| Text::Levenshtein.distance(x.to_s, y.to_s) <= distance}
    end

    choices = []
    strings.each_with_index do |string, i|
      matches = 0
      strings.each do |other|
        matches += 1 if match.call(string, other)
      end
      choices << [string, matches] if matches > 1 and !choices.include?([string, matches])
    end
    choices.sort! {|x, y| y[1] <=> x[1]}
  end
  
  def save_as_yaml(filename, data)
    FileUtils.mkdir_p File.dirname(filename)
    File.open(filename, 'w') do |file|
      YAML.dump data, file
    end
  end
  
end