class SecureApplicationController < ApplicationController
  
  before_filter :login_required, :except => [:signup]
  before_filter :retrieve_user

end