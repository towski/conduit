class Mirror < ActiveRecord::Base
  named_scope :recent, lambda { {:conditions => ['updated_at > (?)', 1.hour.ago]} }
end
