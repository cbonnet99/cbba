require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ReviewerControllerTest < ActionController::TestCase

  def test_index
    get :index, {}, {:user_id => users(:cyrille).id }
    assert_response :success
  end

  def test_reject
		cyrille = users(:cyrille)
		long = articles(:long)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		old_size = Article.draft.size
		post :reject, {:article_id => long.id, :reason_reject => "Don't like it"   }, {:user_id => cyrille.id }
		assert_redirected_to root_url
		long.reload
		assert_not_nil long.rejected_at
		assert_not_nil long.rejected_by_id
		assert_equal "Don't like it", long.reason_reject
		assert_equal old_size+1, Article.draft.size
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
  def test_reject_user_profile
		cyrille = users(:cyrille)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		old_size = UserProfile.draft.size
		post :reject, {:user_profile_id => cyrille.user_profile.id, :reason_reject => "Don't like it"   }, {:user_id => cyrille.id }
		assert_redirected_to root_url
		cyrille.user_profile.reload
		assert_not_nil cyrille.user_profile.rejected_at
		assert_not_nil cyrille.user_profile.rejected_by_id
		assert_equal "Don't like it", cyrille.user_profile.reason_reject
		assert_equal old_size+1, UserProfile.draft.size
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
  def test_approve_article
		cyrille = users(:cyrille)
		long = articles(:long)
		post :approve, {:article_id => long.id  }, {:user_id => cyrille.id }
		assert_redirected_to reviewer_path(:action => "index")
		long.reload
		assert_not_nil long.approved_at
		assert_not_nil long.approved_by_id
  end
  def test_approve_how_to
		cyrille = users(:cyrille)
		improve = how_tos(:improve)
		post :approve, {:how_to_id => improve.id  }, {:user_id => cyrille.id }
		assert_redirected_to reviewer_path(:action => "index")
		improve.reload
		assert_not_nil improve.approved_at
		assert_not_nil improve.approved_by_id
  end
  def test_approve_profile
		cyrille = users(:cyrille)
		cyrille_profile = user_profiles(:cyrille_profile)
		post :approve, {:user_profile_id => cyrille_profile.id  }, {:user_id => cyrille.id }
		assert_redirected_to reviewer_path(:action => "index")
		cyrille_profile.reload
		assert_not_nil cyrille_profile.approved_at
		assert_not_nil cyrille_profile.approved_by_id
  end
end
