require 'text'

namespace :merge do

  MERGE_DIR = "#{RAILS_ROOT}/data/merged"

  desc "Produce YAML file of letter analysis of Documents"
  task :responses => :environment do    
    Document.all.each do |document|
      earmark = Earmark.new 
      earmark.document_id = document.id
      earmark.response_count = document.letters_count
      earmark.scribd_url = "http://www.scribd.com/doc/#{document.scribd_doc_id}/"
      [:amount, :project_title, :funding_purpose, :legislator_id].each do |field|
        answer, certainty = best document.letters.map(&field)
        earmark.send "#{field}=", answer
        earmark.send "#{field}_certainty=", certainty
      end
      earmark.save!
    end
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
  
end