class UrlsController < ApplicationController
  before_filter :login_required, :only => [:index]
  before_filter :find_user
  
  def index
    @urls = @user.urls
  end
  
  def create
    @user.urls.create params[:url]
    head :ok
  end
  
  protected
  def find_user
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
  end
end