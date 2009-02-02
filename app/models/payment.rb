class Payment < ActiveRecord::Base
  DEFAULT_TYPE = "full_member"
  TYPES = {:full_member => {:title => "Full membership for 1 year", :amount => 9999 },
            :renew_full_member => {:title => "Renewal of full membership for 1 year", :amount => 19999 }
  }
end
