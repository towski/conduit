class MirrorsController < ApplicationController
  def update
    mirror = Mirror.find_or_initialize_by_key(params[:mirror].delete(:key))
    mirror.update_attributes(params[:mirror])
    render :nothing => true
  end
  
  def show
    render :text => Mirror.find(params[:id]).url
  end
end
