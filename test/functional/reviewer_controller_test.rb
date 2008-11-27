require File.dirname(__FILE__) + '/../test_helper'

class ReviewerControllerTest < ActionController::TestCase
  def test_reject
		norma = users(:norma)
		long = articles(:long)
		old_size = Article.draft.size
		post :reject, {:article_id => long.id, :reason_reject => "Don't like it"   }, {:user_id => norma.id }
		assert_redirected_to root_url
		long.reload
		assert_not_nil long.rejected_at
		assert_not_nil long.rejected_by_id
		assert_equal "Don't like it", long.reason_reject
		assert_equal old_size+1, Article.draft.size
  end
  def test_approve
		norma = users(:norma)
		long = articles(:long)
		post :approve, {:article_id => long.id  }, {:user_id => norma.id }
		assert_redirected_to root_url
		long.reload
		assert_not_nil long.approved_at
		assert_not_nil long.approved_by_id
  end
end
