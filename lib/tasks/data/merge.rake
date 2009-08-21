namespace :merge do

  MERGE_DIR = "#{RAILS_ROOT}/data/merged"

  desc "Merge responses into Earmark objects"
  task :responses => :environment do
  
    Earmark.delete_all
    i = 0
    distance = ENV['DISTANCE'].to_i
    Document.all.each do |document|
      puts "  [#{i+1}] Merging responses for Document ##{document.id}"
      earmark = Earmark.new 
      
      # document properties worth keeping
      earmark.document_id = document.id
      earmark.response_count = document.letters_count
      earmark.scribd_url = "http://www.scribd.com/doc/#{document.scribd_doc_id}/"
      
      # scalar values
      [:amount, :project_title, :funding_purpose, :legislator_id].each do |field|
        answer, certainty = best document.letters.map {|l| l.send(field).to_s}, distance
        earmark.send "#{field}=", answer
        earmark.send "#{field}_certainty=", certainty
      end
      
      # entity names and address      
      names, certainty = best document.letters.map {|l| l.entities.map {|e| e.name}.join("\n")}, distance
      earmark.entity_names = names
      earmark.entity_names_certainty = certainty
      addresses, certainty = best document.letters.map {|l| l.entities.map {|e| e.address}.join("\n")}, distance
      earmark.entity_addresses = addresses
      earmark.entity_addresses_certainty = certainty
      
      earmark.save!
      i += 1
    end
    puts "Merged #{i} earmark responses, using distance of #{distance}."
  end
  

  def best(strings, distance = 0)
    choices = matches(strings, distance)
    choices.first || [strings.first, 1]
  end
  
  def matches(strings, distance = 0)
    levenshtein = Levenshtein.new
    match = if distance == 0
      lambda {|x, y| x == y}
    else
      lambda {|x, y| levenshtein.distance(x.to_s, y.to_s) <= distance}
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
  
end