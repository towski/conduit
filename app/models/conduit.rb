class Conduit < ActiveRecord::Base
  named_scope :recent, lambda { {:conditions => ['updated_at > (?)', 1.hour.ago], :order => "updated_at desc", :limit => 8} }
  validates_uniqueness_of :key
  validates_presence_of :key
  before_create :set_url
  
  def set_url
    self.url = "http://www.google.com"
  end
end
