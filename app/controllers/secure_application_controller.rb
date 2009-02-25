class SecureApplicationController < ApplicationController
  
  before_filter :login_required, :except => [:signup]

end