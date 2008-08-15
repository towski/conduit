class Conduit < ActiveRecord::Base
  named_scope :recent, lambda { {:conditions => ['updated_at > (?)', 1.hour.ago], :order => "updated_at desc"} }
  
  before_create :set_url
  
  def set_url
    self.url = $HOST_NAME
  end
end
