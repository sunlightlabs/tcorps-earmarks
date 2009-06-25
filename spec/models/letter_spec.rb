require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Letter do
  before(:each) do
    @valid_attributes = {
      :amount                 => 3500000,
      :project_title          => "Bridge Maintenance",
      :fiscal_year            => 2009,
      :funding_purpose        => "Bridge improvements in the Midwest.",
      :taxpayer_justification => "Long term investment in infrastructure.",
      :task_key               => "00000000000000000000000000000000"
    }
  end

  it "should be valid with default attribute values" do
    letter = Letter.new(@valid_attributes)
    letter.should be_valid
  end
  
  VALID_AMOUNTS = [
    "$2,500,000",
    " $2,500,000   ",
    "$2500000",
    "2,500,000",
    "2,500,000   ",
    "2500000",
    "   2500000",
    2_500_000
  ]
  VALID_AMOUNTS.each do |val|
    describe ("with %s as amount" % val.inspect) do
      before(:each) do
        @letter = Letter.new(@valid_attributes.merge(:amount => val))
      end

      it "should be a valid record" do
        @letter.should be_valid
      end

      it "should parse amount as 2,500,000" do
        @letter.valid?
        @letter.amount.should == BigDecimal.new("2_500_000")
      end
    end
  end

  INVALID_AMOUNTS = [
    "requesting $2,500,000",
    "H-218",
    "-----",
    "50 states"
  ]
  INVALID_AMOUNTS.each do |val|
    describe ("with %s as amount" % val.inspect) do
      before(:each) do
        @letter = Letter.new(@valid_attributes.merge(:amount => val))
      end
    
      it "should not be a valid record" do
        @letter.should_not be_valid
      end
    end
  end

end
