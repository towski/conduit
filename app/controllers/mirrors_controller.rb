class MirrorsController < ApplicationController
  def index
    render :file => RAILS_ROOT+"/extension/mirror.xpi", :content_type => "application/x-xpinstall"
  end
  
  def update
    mirror = Mirror.find_or_initialize_by_key(params[:id])
    mirror.update_attributes(params[:mirror])
    render :nothing => true
  end
  
  def show
    render :text => Mirror.find_by_key(params[:id]).url
  end
end
