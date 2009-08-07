require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Document do
  before(:each) do
    @valid_attributes = {
      :title         => nil,
      :source_url    => nil,
      :source_file   => nil,
      :scribd_doc_id => nil,
      :access_key    => nil,
      :plain_text    => nil,
      :legislator_id => nil,
    }
  end

  it "should create a new instance given valid attributes" do
    SourceDoc.create! @valid_attributes
  end
end
