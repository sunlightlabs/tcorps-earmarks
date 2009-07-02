namespace :data do
  
  namespace :scribd do

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
          puts "  Sleeping 10 seconds"
          sleep 10
        end
      end

      puts "Scribd loading complete."
    end
    
    def create_scribd_doc(source_doc)
      title           = source_doc.title
      url             = source_doc.source_url
      legislator_name = source_doc.legislator.name
      puts "  Storing #{url} to Scribd"
      scribd_doc = Scribd::Document.new
      scribd_doc.file = url
      scribd_doc.title = "Earmark Request : #{legislator_name} : #{title}"
      scribd_doc.description = HeredocUtil.prettify <<-END
        This is an earmark request letter from #{legislator_name}.
      
        The original document can be found here: 
        #{url}
      END
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
