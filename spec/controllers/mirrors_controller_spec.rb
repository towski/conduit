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
    get :download
    response.content_type.should == "application/x-xpinstall"
    response.body.should =~ %r(extension/mirror.xpi)
  end
  
  it "can list all the available mirrors" do
    get :index
    assigns(:mirrors).should_not be_nil
  end
  
  it "lists only the latest, which have been updated in the past hours" do
    past = 2.days.ago
    now = Time.now
    Time.stub!(:now).and_return past
    Mirror.create!
    Time.stub!(:now).and_return now
    Mirror.create!
    get :index
    assigns(:mirrors).size.should == 1
  end

end
