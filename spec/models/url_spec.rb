require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Url do
  before(:all) do
    User.delete_all
    @user = User.create!(:login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69')
  end
  
  it "belongs to user" do
    url = Url.create! :url => "http://kaka.com", :user => @user
    @user.urls(true).should == [url]
  end
end