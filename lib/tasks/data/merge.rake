namespace :merge do

  MERGE_DIR = "#{RAILS_ROOT}/data/merged"

  desc "Merge responses into Earmark objects"
  task :responses => :environment do
  
    i = 0
    distance = ENV['DISTANCE'].to_i
    Document.all(:limit => 5).each do |document|
      puts "  [##{i+1}] Merging responses for Document #{document.id}"
      earmark = Earmark.find_or_initialize_by_document_id document.id
      if earmark.id
        puts "  Updating existing Earmark #{earmark.id}"
      end
      
      if ENV['FIELD'].present?
        update_earmark earmark, ENV['FIELD'].to_sym, distance
      else
        # document properties worth keeping
        earmark.document_id = document.id
        earmark.response_count = document.letters_count
        earmark.scribd_url = "http://www.scribd.com/doc/#{document.scribd_doc_id}/"
        
        [:amount, :project_title, :funding_purpose, :legislator_id, :entity_names, :entity_addresses].each do |field|
          update_earmark earmark, field, distance
        end
      end
      
      earmark.save!
      i += 1
    end
    puts "Merged #{i} earmark responses, using distance of #{distance}."
  end
  
  def update_earmark(earmark, field, distance)
    case field
    when :amount, :project_title, :funding_purpose, :legislator_id
      answer, certainty = best earmark.document.letters.map {|l| l.send(field).to_s}, distance
      earmark.send "#{field}=", answer
      earmark.send "#{field}_certainty=", certainty
    when :entity_names, :entity_addresses
      entity_field = field.to_s.gsub('entity_', '').singularize
      
      values, certainty = best earmark.document.letters.map {|l| l.entities.map {|e| e.send(entity_field)}.join("\n")}, distance
      earmark.send "#{field}=", values
      earmark.send "#{field}_certainty=", certainty
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