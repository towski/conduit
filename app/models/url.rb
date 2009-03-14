require 'digest/sha1'

class Url < ActiveRecord::Base
  belongs_to :user
  
  def to_s
    url
  end
end