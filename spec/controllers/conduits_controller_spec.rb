require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConduitsController do

  it "updates with a url and key" do
    put :update, :conduit => {:url => "http://bymatthew.com", :key => "rabble"}
    response.body.should be_blank
    response.should be_success
    Conduit.find_by_key("rabble").should_not be_nil
  end
  
  it "gets the current url" do
    conduit = Conduit.create :key => "rabble"
    get :show, :id => conduit.key
    response.body.should == conduit.reload.url
  end
  
  it "can download the app" do
    get :download
    response.content_type.should == "application/x-xpinstall"
    response.body.should =~ %r(extension/conduit.xpi)
  end
  
  it "can list all the available conduits" do
    get :index
    assigns(:conduits).should_not be_nil
  end
  
  it "lists only the latest, which have been updated in the past hours" do
    past = 2.days.ago
    now = Time.now
    latest = 2.seconds.from_now
    Time.stub!(:now).and_return past
    Conduit.create!
    Time.stub!(:now).and_return now
    Conduit.create!
    Time.stub!(:now).and_return latest
    latest_conduit = Conduit.create!
    get :index
    assigns(:conduits).size.should == 1
    assigns(:latest_conduit).should == latest_conduit
  end

end
