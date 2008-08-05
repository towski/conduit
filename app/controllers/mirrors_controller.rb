class MirrorsController < ApplicationController
  def update
    Mirror.find_or_create_by_key(params[:mirror].delete(:key), params[:mirror])
    render :nothing => true
  end
end
