require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ExpertApplicationsControllerTest < ActionController::TestCase
  fixtures :all

  def test_approve
    applying_expert = expert_applications(:applying_expert)
		post :approve, {:id => applying_expert.id  }, {:user_id => users(:cyrille).id }
#		assert_redirected_to root_url
		applying_expert.reload
		assert_not_nil applying_expert.approved_at
		assert_not_nil applying_expert.approved_by_id
  end

  def test_reject
    applying_expert = expert_applications(:applying_expert)
		post :reject, {:id => applying_expert.id }, {:user_id => users(:cyrille).id }
#		assert_redirected_to root_url
		applying_expert.reload
		assert_not_nil applying_expert.rejected_at
		assert_not_nil applying_expert.rejected_by_id
  end

  def test_approve_with_subcategory_already_taken
    applying_expert = expert_applications(:applying_expert)
    applying_expert.subcategory_id = subcategories(:hypnotherapy).id
    applying_expert.save
		post :approve, {:id => applying_expert.id }, {:user_id => users(:cyrille).id }
#		assert_redirected_to root_url
    assert_equal "This modality already has an expert: Cyrille Bonnet [cbonnet99@yahoo.fr]. Please select a different modality", flash[:error]
		applying_expert.reload
		assert_nil applying_expert.approved_at
		assert_nil applying_expert.approved_by_id
  end

  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
    assert !assigns(:expert_applications).blank?
    assert_match %r{This modality already has a resident expert}, @response.body
  end

  def test_edit_reject_reason
    applying_expert = expert_applications(:applying_expert)
    get :edit_reject_reason, {:id => applying_expert.id}, {:user_id => users(:cyrille).id }
    assert_response :success
  end

end
