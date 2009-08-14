class CreateEarmarks < ActiveRecord::Migration
  def self.up
    create_table :earmarks do |t|
      t.string :project_title
      t.decimal :amount
      t.text :funding_purpose
      t.string :legislator_id
      
      t.decimal :project_title_certainty
      t.decimal :amount_certainty
      t.decimal :funding_purpose_certainty
      t.decimal :legislator_id_certainty
      
      # not specific to earmarks
      t.integer :document_id
      t.string :scribd_url
      t.integer :response_count
    end
  end

  def self.down
    drop_table :earmarks
  end
end