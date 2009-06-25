require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DocParser do
  
  describe "(Town of Garden City)" do
    
    before(:each) do
      example = %{April 3, 2009\n\nChairman David Obey House Appropriations Committee H-218, the Capitol Washington, DC 20515\n\nRanking Member Jerry Lewis House Appropriations Committee 1016 Longworth House Office Building Washington, DC 20515\n\nDear Chairman Obey & Ranking Member Lewis: I am requesting $240,000.00 for Garden City Water Project in fiscal year 2010. The entity to receive funding for this project is Town of Garden City, located at PO Box 172 Garden City, AL 35070. The funding would be used to provide a backup water source to reduce DBP's in the system. Therefore, allowing the customer's water quality to improve. Taxpayer Justification: Compliance with EPA ISDE regulations, improving the water supply to all customers. I certify that neither I nor my spouse has any direct financial interest in this project. Also, I hereby certify that this request will be made publicly available on my Official Website as required by Chairman Obey\342\200\231s new Committee policy that only posted requests will be considered. Consistent with the Republican Leadership\342\200\231s policy on earmarks, I hereby certify that to the best of my knowledge this request (1) is not directed to an entity or program that will be named after a sitting Member of Congress; (2) is not intended to be used by an entity to secure funds for other entities unless the use of funding is consistent with the specified purpose of the earmark; and (3) meets or exceeds all statutory requirements for matching funds where applicable. I further certify that should this request be included in the bill, I will place a statement in the Congressional Record describing how the funds will be spent and justifying the use of federal taxpayer funds. Sincerely,\n\nA\nRobert B. Aderholt\n\n\f}
      @match = DocParser.best_match(example)
    end
    
    it "should give an overall match" do
      @match.should be_true
    end
    
    it "should match the amount" do
      @match[:amount].should == "$240,000.00"
    end
  
    it "should match the project_title" do
      @match[:project_title].should == "Garden City Water Project"
    end
  
    it "should match the fiscal_year" do
      @match[:fiscal_year].should == "2010"
    end
  
    it "should match the entity_name" do
      @match[:entity_name].should == "Town of Garden City"
    end
    
    it "should match the entity_address" do
      @match[:entity_address].should == "PO Box 172 Garden City, AL 35070"
    end
    
    it "should match the funding_purpose" do
      @match[:funding_purpose].should == "The funding would be used to provide a backup water source to reduce DBP's in the system. Therefore, allowing the customer's water quality to improve."
    end
    
    it "should match the taxpayer_justification" do
      @match[:taxpayer_justification].should == "Compliance with EPA ISDE regulations, improving the water supply to all customers."
    end
    
  end
  
  describe "(Fayette Sewer System Improvement Project)" do
    
    before(:each) do
      example = %{Dear Chairman Obey & Ranking Member Lewis: I am requesting $500,000.00 for the Fayette Sewer System Improvement Project in fiscal year 2010. The entity to receive funding for this project is City of Fayette, located at 102 Second Avenue Fayette, AL 35555. The funding would be used to rehabilitate the waste water system along Highway 171 and 7th Avenue. The sewerlines have cracked allowing infiltration to enter the lines. As a result sewer system overflows are a major problem in this area. Taxpayer Justification: Funding of this project will eliminate a serious health threat to the residents of this section of Fayette, Alabama. I certify that neither I nor my spouse has any direct financial interest in this project. Also, I hereby certify that this request will be made publicly available on my Official Website as required by Chairman Obey’s new Committee policy that only posted requests will be considered. Consistent with the Republican Leadership’s policy on earmarks, I hereby certify that to the best of my knowledge this request (1) is not directed to an entity or program that will be named after a sitting Member of Congress; (2) is not intended to be used by an entity to secure funds for other entities unless the use of funding is consistent with the specified purpose of the earmark; and (3) meets or exceeds all statutory requirements for matching funds where applicable. I further certify that should this request be included in the bill, I will place a statement in the Congressional Record describing how the funds will be spent and justifying the use of federal taxpayer funds.}
      @match = DocParser.best_match(example)
    end
  
    it "should give an overall match" do
      @match.should be_true
    end
    
    it "should match the amount" do
      @match[:amount].should == "$500,000.00"
    end
  
    it "should match the project_title" do
      @match[:project_title].should == "Fayette Sewer System Improvement Project"
    end
  
    it "should match the fiscal_year" do
      @match[:fiscal_year].should == "2010"
    end
  
    it "should match the entity_name" do
      @match[:entity_name].should == "City of Fayette"
    end
  
    it "should match the entity_address" do
      @match[:entity_address].should == "102 Second Avenue Fayette, AL 35555"
    end
  
    it "should match the funding_purpose" do
      @match[:funding_purpose].should == "The funding would be used to rehabilitate the waste water system along Highway 171 and 7th Avenue. The sewerlines have cracked allowing infiltration to enter the lines. As a result sewer system overflows are a major problem in this area."
    end
  
    it "should match the taxpayer_justification" do
      @match[:taxpayer_justification].should == "Funding of this project will eliminate a serious health threat to the residents of this section of Fayette, Alabama."
    end
    
  end
  
  describe "(Bevill State Community College)" do
  
    before(:each) do
      example = %{Dear Chairman Obey & Ranking Member Lewis: I am requesting $800,000 for Bevill State Community College, Fayette, AL, Industrial Maintenance and Welding Infrastructure Project in fiscal year 2010. The entity to receive funding for this project is Alabama Community College System located at 401 Adams Avenue, Montgomery AL 36104. The funding would be used for constructing and equipping a new career technical education facility for Bevill State Community College. The facility will provide state-of-the-art training opportunities in the area of Welding Technology and Industrial Maintenance Technology. Taxpayer Justification: Increases training opportunities to create qualified workers through the nation's community college system. I certify that neither I nor my spouse has any direct financial interest in this project. Also, I hereby certify that this request will be made publicly available on my Official Website as required by Chairman Obey’s new Committee policy that only posted requests will be considered.}
      @match = DocParser.best_match(example)
    end
  
    it "should give an overall match" do
      @match.should be_true
    end
  
    it "should match the amount" do
      @match[:amount].should == "$800,000"
    end
      
    it "should match the project_title" do
      @match[:project_title].should == "Bevill State Community College, Fayette, AL, Industrial Maintenance and Welding Infrastructure Project"
    end

    it "should match the fiscal_year" do
      @match[:fiscal_year].should == "2010"
    end
      
    it "should match the entity_name" do
      @match[:entity_name].should == "Alabama Community College System"
    end
      
    it "should match the entity_address" do
      @match[:entity_address].should == "401 Adams Avenue, Montgomery AL 36104"
    end
      
    it "should match the funding_purpose" do
      @match[:funding_purpose].should == "The funding would be used for constructing and equipping a new career technical education facility for Bevill State Community College. The facility will provide state-of-the-art training opportunities in the area of Welding Technology and Industrial Maintenance Technology."
    end
      
    it "should match the taxpayer_justification" do
      @match[:taxpayer_justification].should == "Increases training opportunities to create qualified workers through the nation's community college system."
    end
    
  end
  
  describe "(Short snippet for $500,000.00)" do
  
    before(:each) do
      example = %{Dear Chairman Obey & Ranking Member Lewis: I am requesting $500,000.00 for}
      @match = DocParser.best_match(example)
    end
  
    it "should give an overall match" do
      @match.should be_true
    end
  
    it "should match the amount" do
      @match[:amount].should == "$500,000.00"
    end

  end
  
end
