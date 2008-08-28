class ConduitsController < ApplicationController
  def index
    @conduits = Conduit.recent
  end
  
  def create
    @conduit = Conduit.new(params[:conduit])
    if @conduit.save
      redirect_to conduit_path(:id => @conduit.key.gsub(/ /,'_')), :format => :html
    else
      render :action => :new
    end
  end
  
  def update
    @conduit = Conduit.find_by_key(params[:id].gsub(/_/,' '))
    @conduit.update_attributes(params[:conduit])
    render :nothing => true
  end
  
  def show
    @conduit = Conduit.find_by_key(params[:id].gsub(/_/,' '))
    respond_to do |format|
      if @conduit.private and current_user != @conduit.user and not @conduit.watchers.include?(current_user)
        format.html { render :status => :not_authorized }
      else
        format.html 
        format.json { render :json => @conduit.url, :layout => false }
        format.js
      end
    end
  end
  
  def download
    render :file => RAILS_ROOT+"/extension/conduit.xpi", :content_type => "application/x-xpinstall"
  end
  
  protected
  
  def authorized?
    false
  end
end
