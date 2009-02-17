require File.dirname(__FILE__) + '/../spec_helper'

describe UrlsController do
  before :all do
    User.delete_all
    Url.delete_all
    @user = User.create!(:login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69')
    @other_user = User.create!(:login => 'quires', :email => 'quires@example.com', :password => 'quire69', :password_confirmation => 'quire69')
    @url = @user.urls.create :url => "http://kayak.com"
    @other_url = @other_user.urls.create :url => "http://kayaks.com"
  end
    
  it "gets the current user urls" do
    login @user
    get :index
    assigns[:urls].should == [@url]
  end
  
  it "gets the passed users urls" do
    login @user
    get :index, :user_id => @other_user.id
    assigns[:urls].should == [@other_url]
  end
  
  it "creates urls" do
    login @user
    post :create, :url => {:url => "http://chugalog.com"}, :user_id => @user.id
    response.should be_success
  end
end