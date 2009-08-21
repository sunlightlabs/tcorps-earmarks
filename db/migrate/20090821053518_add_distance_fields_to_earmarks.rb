class AddDistanceFieldsToEarmarks < ActiveRecord::Migration
  def self.up
    [:project_title, :amount, :legislator_id, :funding_purpose, :entity_names, :entity_addresses].each do |field|
      add_column :earmarks, "#{field}_fuzziness", :integer
      rename_column :earmarks, "#{field}_certainty", "#{field}_agreement"
    end
  end

  def self.down
    [:project_title, :amount, :legislator_id, :funding_purpose, :entity_names, :entity_addresses].each do |field|
      rename_column :earmarks, "#{field}_agreement", "#{field}_certainty"
      remove_column :earmarks, "#{field}_fuzziness"
    end
  end
end
