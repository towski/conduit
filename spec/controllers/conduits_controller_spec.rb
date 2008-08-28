require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ConduitsController do
  describe "update" do
    define_models
    
    it "updates with a url and key" do
      put :update, :id => conduits(:default).key
      response.body.should be_blank
      response.should be_success
    end
    
    it "converts _s to  s" do
      conduit = Conduit.create :key => "rabble rabble"
      put :update, :id => "rabble_rabble", :conduit => {:url => "http://bymatthew.com"}
      response.should be_success
      conduit.reload.url.should == "http://bymatthew.com/"
    end
  end

  describe "show" do
    define_models 
    
    before do
      login :default
    end
    
    it "gets the current url" do
      conduit = conduits(:default)
      get :show, :id => conduit.key, :format => "json"
      response.should be_success
      response.body.should == conduit.reload.url
    end

    it "shows and creates a new tab if requested with html" do
      conduit = Conduit.create :key => "rabbless"
      get :show, :id => conduit.key
      response.should be_success
      response.should render_template(:show)
    end
    
    it "doesn't allow the viewing of private conduits except by authorized users" do
      conduits(:default).update_attribute :private, true
      get :show, :id => conduits(:default).key
      response.should_not be_success
      response.should render_template(:show)
    end
    
    it "allows the conduit owner to see it, if private" do
      conduits(:default).update_attribute :user, users(:default)
      get :show, :id => conduits(:default).key
      response.should be_success
    end
    
    it "allows people the conduit owner allows to see it" do
      conduits(:default).watchers << users(:default)
      get :show, :id => conduits(:default).key
      response.should be_success
    end
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
  
  describe "create" do
    it "should redirect to update when create" do
      post :create, :conduit => {:key => "AYE"}
      response.should be_redirect
    end

    it "allows the creation of private conduits" do
      post :create, :conduit => {:key => "AYE", :private => true}
      response.should be_redirect
    end

    it "fails if the update already exists" do
      Conduit.create :key => "rabble"
      post :create, :conduit => {:url => "http://bymatthew.com", :key => "rabble"}
      response.should_not be_redirect
    end
  end
end
