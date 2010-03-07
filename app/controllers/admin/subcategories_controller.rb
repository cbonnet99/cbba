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

  def index
    @subcategories = Subcategory.find(:all, :include => :category, :order => "categories.name")
  end

  def destroy
    @subcategory = Subcategory.find_by_slug(params[:id])
    if @subcategory.nil?
      flash[:error] = "Could not find this subcategory"
    else
      @subcategory.destroy
      flash[:notice] = "Subcategory deleted"
    end
    redirect_to :action => "index" 
  end
end
