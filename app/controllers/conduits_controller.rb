class ConduitsController < ApplicationController
  def index
    @conduits = Conduit.recent
  end

  def update
    conduit = Conduit.find_or_initialize_by_key(params[:id])
    conduit.update_attributes(params[:conduit])
    render :nothing => true
  end
  
  def show
    render :text => Conduit.find_or_create_by_key(params[:id]).url, :layout => false
  end
  
  def download
    render :file => RAILS_ROOT+"/extension/conduit.xpi", :content_type => "application/x-xpinstall"
  end
end
