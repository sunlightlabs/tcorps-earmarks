## Basic Preparation

This assumes you have already prepared individual documents where one document is meant to be one task.  To digitize 130 pieces of data, have 130 documents.

  * Add all documents to the data/docs folder. Files in this folder are ignored by git.
  * Run "rake data:docs:load_into_db". This will create a Document for any files whose filenames do not appear in the Document table as a Document's source_file.  Do not delete the documents from data/docs yet.
  * Run "rake data:scribd:populate" to send each Document which has not sent its document to Scribd, to Scribd.  You can now delete the documents in data/docs.
  * Run "rake data:scribd:update_plain_text" to use the Scribd API to get the plain text for each document. You may want to wait a little bit so that Scribd has time to finish processing the documents you uploaded in step 4. If a document hasn't yet been processed by Scribd, the rake task will let you know its status, and you can try running it again later.
  * Run "rake data:backup:all" to backup the Legislator and Document tables to YAML.  These directories are ignored by the repository. You can transfer these to another machine and run "rake data:restore:all" to restore the database from these files, so that (for example) your staging and production machines can use the same Scribd documents you've already created.
    * If you add more columns to either model, that you want to have backed up, edit lib/data_backup_helper.rb and update the arrays of stored fields.
  * To restore the data you've backed up (like on a staging or production machine, for example), run "rake data:restore:all"