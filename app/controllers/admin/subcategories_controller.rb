class Admin::SubcategoriesController < AdminApplicationController
  def new
    @subcategory = Subcategory.new
    @categories = Category.find(:all, :order => "name")
  end
  
  def create
    @subcategory = Subcategory.new(params[:subcategory])
    if @subcategory.save
      flash[:notice] = "Subcategory added"
      redirect_to new_admin_subcategory_url
    else
      flash[:error] = "Subcategory could not be added"
      render :action => "new" 
    end
  end
  
end
