require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Conduit do
  before(:each) do
    @valid_attributes = {
      :key => 1
    }
  end

  it "finds or updates with the correct values" do
    id = Conduit.find_or_create_by_key(@valid_attributes).id
    Conduit.find(1).url.should == $HOST_NAME
  end
end
