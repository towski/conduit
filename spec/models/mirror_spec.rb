require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mirror do
  before(:each) do
    @valid_attributes = {
      :key => 1,
      :url => "http://bymatthew.com"
    }
  end

  it "finds or updates with the correct values" do
    id = Mirror.find_or_create_by_key(@valid_attributes).id
    Mirror.find(1).url.should == @valid_attributes[:url]
  end
end
