require File.dirname(__FILE__) + '/../test_helper'

class GiftVouchersControllerTest < ActionController::TestCase
  fixtures :all
  
  def test_index_public
    get :index_public
  end
  
  def test_create_errors
    post :create, {:gift_voucher => {}, :save_an_publish => "Save & Publish"  }, {:user_id => users(:cyrille).id, }
    assert_not_nil assigns(:gift_voucher)
    assert !assigns(:gift_voucher).errors.blank?
  end
  
  def test_limit_special_offers_for_full_members
    sgardiner = users(:sgardiner)

    GiftVoucher.create(:title => "Title", :description => "Description", :state => "published", :author => sgardiner   )

    new_gift2 = GiftVoucher.create(:title => "Title2", :description => "Description",
      :author => sgardiner)
    post :publish, {:id => new_gift2.id }, {:user_id => sgardiner.id }
    assert_equal "You can only have 1 gift voucher published at any time", flash[:error]
    assert_redirected_to gift_voucher_path(new_gift2)
  end

  def test_limit_special_offers_for_resident_expert
    cyrille = users(:cyrille)

    GiftVoucher.create(:title => "Title", :description => "Description",
      :state => "published", :author => cyrille   )
    GiftVoucher.create(:title => "Title2", :description => "Description",
        :state => "published", :author => cyrille   )
    GiftVoucher.create(:title => "Title3", :description => "Description",
        :state => "published", :author => cyrille   )
    title4 = GiftVoucher.create(:title => "Title4", :description => "Description",
        :author => cyrille   )

    post :publish, {:id => title4.id }, {:user_id => cyrille.id }
    assert_equal "You can only have 3 gift vouchers published at any time", flash[:error]
    assert_redirected_to gift_voucher_path(title4)
  end

  def test_publish
    cyrille = users(:cyrille)
    one = GiftVoucher.create(:title => "Title4", :description => "Description",
        :author => cyrille   )
    old_published_count = cyrille.published_gift_vouchers_count
    post :publish, {:id => one.id }, {:user_id => cyrille.id }
    assert_equal "Gift voucher successfully published", flash[:notice]
    assert_redirected_to gift_voucher_path(one)
    cyrille.reload
    one.reload
    assert_not_nil one.published_at
    assert_equal old_published_count+1, cyrille.published_gift_vouchers_count
  end

  def test_unpublish
    cyrille = users(:cyrille)
    free_trial = GiftVoucher.create(:title => "Title", :description => "Description",
      :state => "published", :author => cyrille   )
    old_published_count = cyrille.published_gift_vouchers_count
    post :unpublish, {:id => free_trial.id }, {:user_id => cyrille.id }
    assert_redirected_to gift_voucher_path(free_trial)
    cyrille.reload
    assert_equal old_published_count-1, cyrille.published_gift_vouchers_count
  end

  def test_create
    cyrille = users(:cyrille)
    old_count = cyrille.gift_vouchers_count
    old_size = cyrille.gift_vouchers.size
    post :create, {:gift_voucher => {:title => "Title", :description => "Description"} }, {:user_id => cyrille.id }
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
  
  def test_index
    cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_template 'index'
  end

  def test_show
    get :show, {:id => gift_vouchers(:free_massage).slug}, {:user_id => users(:cyrille).id }
    assert_template 'show'
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
