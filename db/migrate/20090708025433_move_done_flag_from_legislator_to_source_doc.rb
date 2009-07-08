class MoveDoneFlagFromLegislatorToSourceDoc < ActiveRecord::Migration
  def self.up
    add_column :source_docs, :done, :boolean, :default => false
    add_index :source_docs, :done
    
    SourceDoc.all.each do |source_doc|
      if source_doc.legislator
        source_doc.update_attribute :done, source_doc.legislator.done
      end
    end
    
    remove_index :legislators, :done
    remove_column :legislators, :done
  end

  def self.down
    add_column :legislators, :done, :boolean, :default => false
    add_index :legislators, :done
    
    Legislator.all.each do |legislator|
      if legislator.source_docs.all.any?
        legislator.update_attribute :done, legislator.source_docs.first.done
      end
    end
    
    remove_index :source_docs, :done
    remove_column :source_docs, :done
  end
end