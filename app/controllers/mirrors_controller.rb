class MirrorsController < ApplicationController
  def update
    mirror = Mirror.find_or_initialize_by_key(params[:mirror].delete(:key))
    mirror.update_attributes(params[:mirror])
    render :nothing => true
  end
end
