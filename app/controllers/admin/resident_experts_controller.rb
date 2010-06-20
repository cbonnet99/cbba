class Admin::ResidentExpertsController < ApplicationController
  def index
    @subcategories = Subcategory.find(:all, :order => "name").reject{|s| s.users_with_points.blank?}
  end
  
  def index_for_subcategory
    @subcategory = Subcategory.find(params[:id])
    unless @subcategory.nil?
      @subcat_resident_experts = @subcategory.resident_experts
      @users_with_points = @subcategory.users_with_points
    end
  end
end
