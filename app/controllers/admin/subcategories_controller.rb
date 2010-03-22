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
    @subcategories2 = Subcategory.find(:all, :include => :category, :order => "categories.name")
  end

  def destroy
    @subcategory = Subcategory.find_by_slug(params[:id])
    if @subcategory.nil?
      flash[:error] = "Could not find this subcategory"
    else
      if !@subcategory.resident_expert.nil?
        flash[:error] = "This subcategory has a resident expert and cannot be deleted"
      else
        if params[:new_subcategory_id]
          @transfer_to = Subcategory.find(params[:new_subcategory_id])
          if @transfer_to.nil?
            flash[:error] = "Could not find the subcategory to transfer"
          else
            @subcategory.users.each do |u|
              u.subcategories.delete(@subcategory)
              u.subcategories << @transfer_to
            end
            @subcategory.destroy
            flash[:notice] = "Subcategory deleted and users transferred to: #{@transfer_to.name}"
          end
        else
          # @subcategory.destroy
          flash[:error] = "Subcategory cannot be deleted: you need to pass a new subcategory to transfer the users to"
        end
      end
    end
    redirect_to :action => "index" 
  end
end
