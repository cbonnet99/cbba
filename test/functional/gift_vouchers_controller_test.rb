require File.dirname(__FILE__) + '/../test_helper'

class GiftVouchersControllerTest < ActionController::TestCase
  include ApplicationHelper
  fixtures :all

  def test_index_for_subcategory_per_country
    subcat = Factory(:subcategory)
    nz = countries(:nz)
    au = countries(:au)
    gv_nz = Factory(:gift_voucher, :country => nz, :state => "published", :subcategory => subcat)
    gv_au = Factory(:gift_voucher, :country => au, :state => "published", :subcategory => subcat)
    
    get :index_for_subcategory, :subcategory_slug  => subcat.slug, :country_code => nz.country_code 
    
    assert !assigns(:gift_vouchers).include?(gv_au), "Oz gift voucher should not be displayed"
    assert assigns(:gift_vouchers).include?(gv_nz), "NZ gift voucher should be displayed"
  end

    
  def test_index_for_subcategory
    therapeutic_massage = subcategories(:therapeutic_massage)
    free_massage = gift_vouchers(:free_massage)
    free_massage_draft = gift_vouchers(:free_massage_draft)
    new_gv = Factory(:gift_voucher, :subcategory => therapeutic_massage, :author => users(:cyrille)  )
    new_gv.publish!
    assert new_gv.published?
    
    get :index_for_subcategory, :subcategory_slug  => therapeutic_massage.slug, :country_code => "nz" 
    
    assert !assigns(:gift_vouchers).include?(free_massage_draft), "Draft article should not be included in index_for_subcategory"
    assert assigns(:gift_vouchers).include?(free_massage), "Published article should be included in index_for_subcategory"
  end    
    
  def test_create_errors
    post :create, {:gift_voucher => {}, :save_an_publish => "Save & Publish"  }, {:user_id => users(:cyrille).id, }
    assert_not_nil assigns(:gift_voucher)
    assert !assigns(:gift_voucher).errors.blank?
  end
  
  def test_limit_special_offers_for_full_members
    sgardiner = users(:sgardiner)
    subcat = Factory(:subcategory)

    GiftVoucher.create(:title => "Title", :description => "Description", :state => "published", :author => sgardiner, :subcategory => subcat   )

    new_gift2 = GiftVoucher.create(:title => "Title2", :description => "Description", :subcategory => subcat,
      :author => sgardiner)
    post :publish, {:id => new_gift2.id }, {:user_id => sgardiner.id }
    assert_equal "You have paid for 1 published gift voucher", flash[:error]
    assert_redirected_to gift_vouchers_url
  end

  def test_limit_special_offers_for_resident_expert
    cyrille = users(:cyrille)
    subcat = Factory(:subcategory)
    
    GiftVoucher.create(:title => "Title", :description => "Description", :subcategory => subcat, 
      :state => "published", :author => cyrille   )
    GiftVoucher.create(:title => "Title2", :description => "Description", :subcategory => subcat,
        :state => "published", :author => cyrille   )
    GiftVoucher.create(:title => "Title3", :description => "Description", :subcategory => subcat,
        :state => "published", :author => cyrille   )
    title4 = GiftVoucher.create(:title => "Title4", :description => "Description", :subcategory => subcat,
        :author => cyrille   )

    post :publish, {:id => title4.id }, {:user_id => cyrille.id }
    assert_equal "You have paid for 3 published gift vouchers", flash[:error]
    assert_redirected_to gift_vouchers_url
  end

  def test_publish
    cyrille = users(:cyrille)
    subcat = Factory(:subcategory)
    one = GiftVoucher.create(:title => "Title4", :description => "Description", :subcategory => subcat, 
        :author => cyrille   )
    old_published_user_count = cyrille.published_gift_vouchers_count
    old_published_subcat_count = CountriesSubcategory.find_by_country_id_and_subcategory_id(one.country_id, subcat.id).published_gift_vouchers_count

    post :publish, {:id => one.id }, {:user_id => cyrille.id }

    assert_equal "\"#{one.title}\" successfully published", flash[:notice]
    assert_redirected_to gift_vouchers_url
    cyrille.reload
    one.reload
    assert_not_nil one.published_at
    assert_equal old_published_user_count+1, cyrille.published_gift_vouchers_count
    assert_equal old_published_subcat_count+1, CountriesSubcategory.find_by_country_id_and_subcategory_id(one.country_id, subcat.id).published_gift_vouchers_count
  end

  def test_unpublish
    cyrille = users(:cyrille)
    subcat = Factory(:subcategory)
    free_trial = GiftVoucher.create(:title => "Title", :description => "Description", :subcategory => subcat, 
      :state => "published", :author => cyrille   )
    old_published_count = cyrille.published_gift_vouchers_count
    post :unpublish, {:id => free_trial.id }, {:user_id => cyrille.id }
    assert_redirected_to gift_vouchers_url
    cyrille.reload
    assert_equal old_published_count-1, cyrille.published_gift_vouchers_count
  end

  def test_create
    cyrille = users(:cyrille)
    old_count = cyrille.gift_vouchers_count
    old_size = cyrille.gift_vouchers.size
    subcat = Factory(:subcategory)
    post :create, {:context => "profile", :selected_tab_id => "offers",  :gift_voucher => {:subcategory => subcat, :title => "Title", :description => "Description"} }, {:user_id => cyrille.id }
    assert_redirected_to gift_vouchers_show_url(assigns(:gift_voucher).author.slug, assigns(:gift_voucher).slug, :context => "profile", :selected_tab_id => "offers")
    new_gift = assigns(:gift_voucher)
    assert_not_nil new_gift
    assert new_gift.errors.blank?, "Errors found in new_gift: #{new_gift.errors.inspect}"
    cyrille.reload
    assert_equal old_size+1, cyrille.gift_vouchers.size
    assert_equal old_count+1, cyrille.gift_vouchers_count
  end
  
  def test_update
    free_massage = gift_vouchers(:free_massage)
    cyrille = users(:cyrille)
    post :update, {:id => free_massage.slug, :gift_voucher => {:title => "TitleNEW"} }, {:user_id => cyrille.id }
    new_gift = assigns(:gift_voucher)
    assert_not_nil new_gift
    assert new_gift.errors.blank?, "Errors found in new_gift: #{new_gift.errors.inspect}"
  end
  
  def test_update_errors
    free_massage = gift_vouchers(:free_massage)
    cyrille = users(:cyrille)
    post :update, {:id => free_massage.slug, :gift_voucher => {:title => "TitleNEW", :description => "a"*650}}, {:user_id => cyrille.id }
    new_gift = assigns(:gift_voucher)
    assert_not_nil new_gift
    assert !new_gift.errors.blank?
  end
  
  def test_index
    cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_template 'index'
  end

  def test_show
    cyrille = users(:cyrille)
    get :show, {:id => gift_vouchers(:free_massage).slug, :selected_user => cyrille.slug }, {:user_id => cyrille.id }
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:gift_voucher)
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 1
  end
  
  def test_show_profile
    cyrille = users(:cyrille)
    get :show, {:context  => "profile", :selected_tab_id => "offers", :id => gift_vouchers(:free_massage).slug, :selected_user => cyrille.slug }
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:gift_voucher)
    assert_template 'show'
    assert_select "a[href$=offers]", {:text => "Back to #{cyrille.name}'s profile", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 0
  end
  
  def test_show_published_not_approved
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:selected_tab_id => "offers", :id => gift_vouchers(:published_not_approved).slug, :selected_user => rmoore.slug }, {:user_id => cyrille.id }
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:gift_voucher)
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 1
  end
  
  def test_show_published_and_approved
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:selected_tab_id => "offers", :id => gift_vouchers(:published_and_approved).slug, :selected_user => rmoore.slug }, {:user_id => cyrille.id }
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:gift_voucher)
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 0
  end
  
  def test_show_rejected
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:selected_tab_id => "offers", :id => gift_vouchers(:rejected).slug, :selected_user => rmoore.slug }, {:user_id => cyrille.id }
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:gift_voucher)
    assert_template 'show'
    assert_select "div[class=publication-actions]", :count => 1
  end
  
  def test_new
    get :new, {}, {:user_id => users(:cyrille).id }
    assert_template 'new'
  end
  
  def test_edit
    get :edit, {:id => gift_vouchers(:free_massage).slug}, {:user_id => users(:cyrille).id }
    assert_template 'edit'
  end

  def test_destroy
    free_massage = gift_vouchers(:free_massage)
    cyrille = users(:cyrille)
    old_count = cyrille.gift_vouchers.size
    old_published_count = cyrille.published_gift_vouchers_count
    delete :destroy, {:id => free_massage.slug}, {:user_id => cyrille.id }
    assert_redirected_to gift_vouchers_url
    assert !GiftVoucher.exists?(free_massage.id)
    cyrille.reload
    assert_equal old_count-1, cyrille.gift_vouchers.size
    assert_equal old_published_count-1, cyrille.published_gift_vouchers_count
  end

  
end
