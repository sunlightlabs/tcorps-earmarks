namespace :data do
  
  namespace :scribd do

    DOCS_DIR = "#{RAILS_ROOT}/data/docs"

    desc "Tell Scribd to grab PDFs as specified by SourceDoc database."
    task :populate => :environment do
      puts "Using Scribd API to fetch SourceDocs urls"
      source_docs = if ENV['LEGISLATOR_ID'] and legislator = Legislator.find_by_id(ENV['LEGISLATOR_ID'])
        legislator.source_docs.all
      else
        SourceDoc.all
      end
      
      source_docs.each do |source_doc|
        if source_doc.scribd_doc_id
          puts "  Skipping SourceDoc id #{source_doc.id}; already stored at Scribd id #{source_doc.scribd_doc_id}"
        else
          if scribd_doc = create_scribd_doc(source_doc)
            source_doc.scribd_doc_id = scribd_doc.doc_id
            source_doc.access_key    = scribd_doc.access_key
            source_doc.save!
          end
          puts "  Sleeping 5 seconds"
          sleep 5
        end
      end

      puts "Scribd loading complete."
    end
    
    def create_scribd_doc(source_doc)
      puts "  Storing #{source_doc.title} to Scribd"
      scribd_doc = Scribd::Document.new
      
      # documents may not have a legislator known going in
      if source_doc.legislator
        scribd_doc.title = "Earmark Request : #{legislator_name} : #{source_doc.title}"
        scribd_doc.description = "This is an earmark request letter from #{legislator_name}."
      else
        scribd_doc.title = "Earmark Request"
        scribd_doc.description = "This is an earmark request letter from a member of Congress."
      end
      
      # individual documents may not have a reference URL online
      if source_doc.source_url
        scribd_doc.description << "\n\nThe original document can be found here:\n#{source_doc.source_url}"
        scribd_doc.file = url
      elsif source_doc.source_file
        scribd_doc.file = File.join(DOCS_DIR, source_doc.source_file)
      else
        raise Exception.new("No source file or URL for SourceDoc with ID #{source_doc.id}!")
      end
      
      scribd_doc.license = "pd" # Public Domain
      scribd_doc.tags = "earmark request,sunlight foundation"
      
      if scribd_doc.save 
        puts "  Successfully sent to scribd!"
        scribd_doc
      else
        puts "  Failed to send document to scribd."
        nil
      end
    end
  
    desc "Update plain text in SourceDoc from Scribd."
    task :update_plain_text => :environment do
      puts "Using Scribd API to fetch plain text for each SourceDoc."
      count = 0
      all_source_docs = SourceDoc.all
      all_source_docs.each do |source_doc|
        if source_doc.plain_text
          puts "  Skipping SourceDoc id #{source_doc.id} because it already has plain text stored."
          next
        end

        doc_id = source_doc.scribd_doc_id
        scribd_doc = Scribd::Document.find(doc_id)
        if scribd_doc
          status = scribd_doc.conversion_status
          if status == "DONE"
            plain_text_url = scribd_doc.download_url('txt')
            plain_text = open(plain_text_url).read
            source_doc.plain_text = plain_text
            source_doc.save!
            count += 1
            puts "  Saved plain text for SourceDoc id #{source_doc.id}."
          elsif status == "ERROR"
            source_doc.plain_text = ""
            source_doc.conversion_failed = true
            source_doc.save!
            puts "  The Scribd document conversion failed.  Saving '' to plain text field."
          else
            puts "  Scribd reports this status: #{status}."
          end
        end
        sleep 1
      end
      puts "Updated #{count} of #{all_source_docs.length} SourceDoc plain_text fields."
    end
  
    def make_title(string)
      string.sub(".pdf", "")
    end

  end

end
