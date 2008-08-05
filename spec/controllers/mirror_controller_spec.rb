require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MirrorController do

  it "updates with a url and key" do
    put :update, :mirror => {:url => "http://bymatthew.com", :key => 1}
    response.body.should be_blank
    response.should be_success
    Mirror.find_by_key(1).should_not be_nil
  end

end
