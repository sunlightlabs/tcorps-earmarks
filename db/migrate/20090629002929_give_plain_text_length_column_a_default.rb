class GivePlainTextLengthColumnADefault < ActiveRecord::Migration
  def self.up
    change_column_default :source_docs, :plain_text_length, 0
  end

  def self.down
    # no valid db-agnostic reverse
  end
end
