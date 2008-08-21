require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConduitsController do

  it "updates with a url and key" do
    put :update, :id => "rabble", :conduit => {:url => "http://bymatthew.com"}
    response.body.should be_blank
    response.should be_success
    Conduit.find_by_key("rabble").should_not be_nil
  end
  
  it "fails if the update already exists" do
    Conduit.create :key => "rabble"
    post :create, :conduit => {:url => "http://bymatthew.com", :key => "rabble"}
    response.should_not be_redirect
  end
  
  it "gets the current url" do
    conduit = Conduit.create :key => "rabble"
    get :show, :id => conduit.key, :format => "json"
    response.body.should == conduit.reload.url
  end
  
  it "shows and creates a new tab if requested with html" do
    conduit = Conduit.create :key => "rabble"
    get :show, :id => conduit.key
    response.should render_template(:show)
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
    Time.stub!(:now).and_return past
    Conduit.create! :key => "a"
    Time.stub!(:now).and_return now
    Conduit.create! :key => "b"
    get :index
    assigns(:conduits).size.should == 1
  end
  
  it "allows users to create a new conduit" do
    get :new
    response.should be_success
  end
  
  it "should redirect to update when create" do
    post :create, :conduit => {:key => "AYE"}
    response.should be_redirect
  end
end
