class Conduit < ActiveRecord::Base
  named_scope :recent, lambda { {:conditions => ['updated_at > (?)', 1.hour.ago], :order => "updated_at desc", :limit => 8} }
  validates_uniqueness_of :key
  validates_presence_of :key
  before_create :set_url
  belongs_to :user
  has_and_belongs_to_many :watchers, :class_name => "User"
  
  def set_url
    self.url = "http://www.google.com/" unless url
  end
  
  def url=(new_url)
    if URI.parse(new_url).path.blank?
      new_url += "/"
    end
    self[:url] = new_url
  end
end
