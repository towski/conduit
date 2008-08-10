require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MirrorsController do

  it "updates with a url and key" do
    put :update, :mirror => {:url => "http://bymatthew.com", :key => "rabble"}
    response.body.should be_blank
    response.should be_success
    Mirror.find_by_key("rabble").should_not be_nil
  end
  
  it "gets the current url" do
    mirror = Mirror.create :key => "rabble", :url => "http://bymatthew.com"
    get :show, :id => mirror.key
    response.body.should == "http://bymatthew.com"
  end
  
  it "can download the app" do
    get :index
    response.content_type.should == "application/x-xpinstall"
    response.body.should == '/Users/matt/git/mirro/mirror.xpi'
  end

end
