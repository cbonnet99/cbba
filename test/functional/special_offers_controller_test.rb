require File.dirname(__FILE__) + '/../test_helper'

class SpecialOffersControllerTest < ActionController::TestCase
  def test_index
    cyrille = users(:cyrille)
    get :index, {}, {:user_id => cyrille.id }
    assert_template 'index'
  end
  
  def test_show
    get :show, {:id => special_offers(:one).slug}, {:user_id => users(:cyrille).id }
    assert_template 'show'
  end
  
  def test_new
    get :new, {}, {:user_id => users(:cyrille).id }
    assert_template 'new'
  end
      
  def test_edit
    get :edit, {:id => special_offers(:one).slug}, {:user_id => users(:cyrille).id }
    assert_template 'edit'
  end
    
  def test_destroy
    special_offer = special_offers(:one)
    delete :destroy, {:id => special_offer.slug}, {:user_id => users(:cyrille).id }
    assert_redirected_to special_offers_url
    assert !SpecialOffer.exists?(special_offer.id)
  end
end
