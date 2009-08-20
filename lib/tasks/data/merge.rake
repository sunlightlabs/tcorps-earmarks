namespace :merge do

  MERGE_DIR = "#{RAILS_ROOT}/data/merged"

  desc "Merge responses into Earmark objects"
  task :responses => :environment do
  
    Earmark.delete_all
    Document.all(:limit => 5).each do |document|
      earmark = Earmark.new 
      
      # document properties worth keeping
      earmark.document_id = document.id
      earmark.response_count = document.letters_count
      earmark.scribd_url = "http://www.scribd.com/doc/#{document.scribd_doc_id}/"
      
      # scalar values
      [:amount, :project_title, :funding_purpose, :legislator_id].each do |field|
        answer, certainty = best document.letters.map(&field)
        earmark.send "#{field}=", answer
        earmark.send "#{field}_certainty=", certainty
      end
      
      # entity names and address      
      entities, certainty = best document.letters.map {|l| l.entities.map {|e| [e.name, e.address].join "\n"}.join("\n\n")}
      earmark.entities = entities
      earmark.entities_certainty = certainty
            
      earmark.save!
    end
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