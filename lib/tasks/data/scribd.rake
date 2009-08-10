namespace :data do
  
  namespace :scribd do

    DOCS_DIR = "#{RAILS_ROOT}/data/docs"

    desc "Tell Scribd to grab PDFs as specified by Document database."
    task :populate => :environment do
      puts "Using Scribd API to fetch Documents urls"
      documents = if ENV['LEGISLATOR_ID'] and legislator = Legislator.find_by_id(ENV['LEGISLATOR_ID'])
        legislator.documents.all
      else
        Document.all
      end
      
      documents.each do |document|
        if document.scribd_doc_id
          puts "  Skipping Document id #{document.id}; already stored at Scribd id #{document.scribd_doc_id}"
        else
          if scribd_doc = create_scribd_doc(document)
            document.scribd_doc_id = scribd_doc.doc_id
            document.access_key    = scribd_doc.access_key
            document.save!
          end
          puts "  Sleeping 2 seconds"
          sleep 2
        end
      end

      puts "Scribd loading complete."
    end
    
    def create_scribd_doc(document)
      puts "  Storing #{document.title} to Scribd"
      scribd_doc = Scribd::Document.new
      
      # documents may not have a legislator known going in
      if document.legislator
        scribd_doc.title = "Earmark Request : #{legislator_name} : #{document.title}"
        scribd_doc.description = "This is an earmark request letter from #{legislator_name}."
      else
        scribd_doc.title = "Earmark Request"
        scribd_doc.description = "This is an earmark request letter from a member of Congress."
      end
      
      # individual documents may not have a reference URL online
      if document.source_url
        scribd_doc.description << "\n\nThe original document can be found here:\n#{document.source_url}"
        scribd_doc.file = url
      elsif document.source_file
        scribd_doc.file = File.join(DOCS_DIR, document.source_file)
      else
        raise Exception.new("No source file or URL for Document with ID #{document.id}!")
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
  
    desc "Update plain text in Document from Scribd."
    task :update_plain_text => :environment do
      puts "Using Scribd API to fetch plain text for each Document."
      count = 0
      all_documents = Document.all
      all_documents.each do |document|
        if document.plain_text
          puts "  Skipping Document id #{document.id} because it already has plain text stored."
          next
        end

        doc_id = document.scribd_doc_id
        scribd_doc = Scribd::Document.find(doc_id)
        if scribd_doc
          status = scribd_doc.conversion_status
          if status == "DONE"
            plain_text_url = scribd_doc.download_url('txt')
            plain_text = open(plain_text_url).read
            document.plain_text = plain_text
            document.save!
            count += 1
            puts "  Saved plain text for Document id #{document.id}."
          elsif status == "ERROR"
            document.plain_text = ""
            document.conversion_failed = true
            document.save!
            puts "  The Scribd document conversion failed.  Saving '' to plain text field."
          else
            puts "  Scribd reports this status: #{status}."
          end
        end
        sleep 1
        puts "  Sleeping for 1 second"
      end
      puts "Updated #{count} of #{all_documents.length} Document plain_text fields."
    end
  
    def make_title(string)
      string.sub(".pdf", "")
    end

  end

end