class AdminApplicationController < SecureApplicationController
  before_filter :admin_required
end