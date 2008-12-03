class Payment < ActiveRecord::Base
  DEFAULT_TYPE = "full_membership"
  TYPES = {:full_membership => {:title => "Full membership for 1 year", :amount => 9999 }}
end
