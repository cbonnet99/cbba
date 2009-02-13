require File.dirname(__FILE__) + '/../test_helper'

class HowTosControllerTest < ActionController::TestCase
	fixtures :all

  def test_create
    cyrille = users(:cyrille)
    old_size = cyrille.how_tos.size
    old_count = cyrille.how_tos_count
    post :create, { :how_to =>
       {:step_label => "step", :title =>"Title here", :summary => "Summary now",
        :new_step_attributes => [
          {:title =>"1st step", "body"=>"blabla"}]}}, {:user_id => cyrille.id }
    assert_not_nil assigns(:how_to)
    assert assigns(:how_to).errors.blank?
    assert_equal flash[:notice], 'HowTo was successfully created.'
    assert_redirected_to how_to_path(assigns(:how_to))
    cyrille.reload
    assert_equal old_size+1, cyrille.how_tos.size
    assert_equal old_count+1, cyrille.how_tos_count
  end

	def test_publish
		improve = how_tos(:improve)
		cyrille = users(:cyrille)
    old_size = cyrille.published_how_tos_count
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {:id => improve.id }, {:user_id => cyrille.id}
		assert_redirected_to root_url
		improve.reload
		assert_not_nil improve.published_at

		#an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0

    cyrille.reload
    assert_equal old_size+1, cyrille.published_how_tos_count
	end

  def test_show
    get :show, {:id => how_tos(:improve).id }, {:user_id => users(:cyrille).id }
    assert_response :success
  end

end