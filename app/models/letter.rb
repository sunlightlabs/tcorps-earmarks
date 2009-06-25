# Earmark Request Letter
class Letter < ActiveRecord::Base
  
  has_many :entities
  belongs_to :user
  belongs_to :source_doc, :counter_cache => true

  validates_associated :user
  validates_associated :entities
  
  validates_presence_of :amount
  validates_presence_of :project_title
  validates_presence_of :fiscal_year
  validates_presence_of :funding_purpose
  validates_presence_of :taxpayer_justification
  validates_presence_of :task_key

  before_validation :validate_amount

  accepts_nested_attributes_for :entities

  protected
  
  def validate_amount
    if @amount_invalid
      errors.add(:amount, "must be a dollar amount")
    end
  end
  
  def amount=(raw)
    value = self.class.strip_dollar_amount(raw)
    normalized = if self.class.valid_dollar_amount?(value)
      self.class.clean_dollar_amount(value)
    else
      @amount_invalid = true
      nil
    end
    super(normalized)
  end
  
  def self.valid_dollar_amount?(item)
    return true if item.class == BigDecimal
    item =~ /^[$]?[\d,]+[.]?[\d]{0,2}$/
  end
  
  def self.strip_dollar_amount(item)
    return item if item.class == BigDecimal
    item.to_s.strip
  end
  
  def self.clean_dollar_amount(value)
    value.to_s.strip.gsub(/[$,]/, "")
  end
  
end
