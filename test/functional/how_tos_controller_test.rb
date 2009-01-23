require File.dirname(__FILE__) + '/../test_helper'

class HowTosControllerTest < ActionController::TestCase
	fixtures :all

	def test_publish
		improve = how_tos(:improve)
		cyrille = users(:cyrille)
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {:id => improve.id }, {:user_id => cyrille.id}
		assert_redirected_to root_url
		improve.reload
		assert_not_nil improve.published_at

		#an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0
	end
end