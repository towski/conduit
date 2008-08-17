require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Conduit do
  before(:each) do
    @valid_attributes = {
      :key => 1
    }
  end

  it "finds or updates with the correct values" do
    id = Conduit.find_or_create_by_key(@valid_attributes).id
    Conduit.find(1).url.should == "http://www.google.com"
  end
  
  it "must have a unique key name" do
    Conduit.create :key => "a"
    lambda { Conduit.create! :key => "a" }.should raise_error
    (Conduit.create :key => "a").errors.should_not be_blank
  end
  
  it "must have a key" do
    Conduit.create.errors.should_not be_blank
  end
  
  it "limits recent to just 8" do
    9.times do |i|
      Conduit.create :key => i
    end
    Conduit.recent.size.should == 8
  end
end
