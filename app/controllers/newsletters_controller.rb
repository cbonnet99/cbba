class NewslettersController < ApplicationController
  
  def index
    @newsletters = Newsletter.find(:all, :conditions => "state='published'", :order => "published_at desc") 
  end
  
  def show
    @newsletter = Newsletter.published.find(params[:id])
  end
end
