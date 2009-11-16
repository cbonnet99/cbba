require File.dirname(__FILE__) + '/../test_helper'

class HowTosControllerTest < ActionController::TestCase
  include ApplicationHelper
	fixtures :all

  def test_destroy
    cyrille = users(:cyrille)
    old_size = cyrille.how_tos.size
    post :destroy, {:id => how_tos(:improve) }, {:user_id => cyrille.id }
    cyrille.reload
    assert_equal old_size-1, cyrille.how_tos.size
  end

  def test_should_get_new
		cyrille = users(:cyrille)
    get :new, {}, {:user_id => cyrille.id }
    assert_response :success
    #should default to the user's main expertise
		assert_select "select#how_to_subcategory1_id > option[value=#{cyrille.subcategories.first.id}][selected=selected]"
  end
  
  def test_create
    cyrille = users(:cyrille)
    old_size = cyrille.how_tos.size
    old_count = cyrille.how_tos_count
    post :create, {:context => "profile", :selected_tab_id => "articles", :how_to =>
       {:step_label => "step", :title =>"Title here", :summary => "Summary now", :subcategory1_id => subcategories(:yoga).id,
        :new_step_attributes => [
          {:title =>"1st step", "body"=>"blabla"}]}}, {:user_id => cyrille.id }
    assert_not_nil assigns(:how_to)
    assert assigns(:how_to).errors.blank?
    assert_equal flash[:notice], "\"Title here\" was successfully saved and published."
    assert_redirected_to how_tos_show_url(cyrille.slug, "title-here", :context => "profile", :selected_tab_id => "articles")
    cyrille.reload
    assert_equal old_size+1, cyrille.how_tos.size
    assert_equal old_count+1, cyrille.how_tos_count
  end

  def test_create_summary_too_long
    cyrille = users(:cyrille)
    old_size = cyrille.how_tos.size
    old_count = cyrille.how_tos_count
    post :create, { :how_to =>
       {:step_label => "step", :title =>"Title", :summary => "S"*501, :subcategory1_id => subcategories(:yoga).id,
        :new_step_attributes => [
          {:title =>"1st step", "body"=>"blabla"}]}}, {:user_id => cyrille.id }
    assert_not_nil assigns(:how_to)
    assert !assigns(:how_to).errors.blank?
    cyrille.reload
    assert_equal old_size, cyrille.how_tos.size
    assert_equal old_count, cyrille.how_tos_count
  end

	def test_publish
		improve = how_tos(:improve)
		cyrille = users(:cyrille)
    old_size = cyrille.published_how_tos_count
		ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

		post :publish, {:context => "profile", :selected_tab_id => "articles", :id => improve.id }, {:user_id => cyrille.id}
		assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
		improve.reload
		assert_not_nil improve.published_at

		#an email should be sent to reviewers
		assert ActionMailer::Base.deliveries.size > 0

    cyrille.reload
    assert_equal old_size+1, cyrille.published_how_tos_count
	end

	def test_unpublish
		money = how_tos(:money)
		cyrille = users(:cyrille)
    old_size = cyrille.published_how_tos_count

		post :unpublish, {:context => "profile", :selected_tab_id => "articles", :id => money.id }, {:user_id => cyrille.id}
		assert_redirected_to expanded_user_url(cyrille, :selected_tab_id => "articles")
		money.reload
		assert_nil money.published_at

    cyrille.reload
    assert_equal old_size-1, cyrille.published_how_tos_count
	end

  def test_show
    cyrille = users(:cyrille)
    get :show, {:context => "profile", :selected_tab_id => "articles",  :id => how_tos(:money).slug, :selected_user => cyrille.slug  }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "input[value=Unpublish]", nil, "Author should be able to unpublish this how to"
    assert_select "a", :text => "Delete"
    assert_select "a", {:text => "Profile", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 1
  end

  def test_show_profile
    cyrille = users(:cyrille)
    money = how_tos(:money)
    get :show, {:context => "profile", :selected_tab_id => "articles",  :id => money.slug, :selected_user => cyrille.slug  }
    assert_response :success
    # puts @response.body
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "a[href$=articles]", {:text => "Back to #{cyrille.name}'s profile", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 0
  end

  def test_show_review
    cyrille = users(:cyrille)
    get :show, {:context => "review", :id => how_tos(:improve).slug, :selected_user => cyrille.slug  }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "a", {:text => "Back to review list", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 1
  end

  def test_show_anonymous_draft
    cyrille = users(:cyrille)
    get :show, {:id => how_tos(:improve).slug, :selected_user => cyrille.slug  }
    assert_redirected_to articles_url
    assert_not_nil assigns(:selected_user)
    assert_nil assigns(:how_to)
  end

  def test_show_anonymous_published
    cyrille = users(:cyrille)
    get :show, {:context => "homepage", :id => how_tos(:money).slug, :selected_user => cyrille.slug  }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "a", {:text => "Back to articles", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 0
  end

  def test_show_logged_published_not_approved
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:context => "homepage", :id => how_tos(:published_not_approved).slug, :selected_user => rmoore.slug  }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "a", {:text => "Back to articles", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 1
  end

  def test_show_logged_published_and_approved
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:context => "homepage", :id => how_tos(:published_and_approved).slug, :selected_user => rmoore.slug  }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "a", {:text => "Back to articles", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 0
  end

  def test_show_logged_rejected
    cyrille = users(:cyrille)
    rmoore = users(:rmoore)
    get :show, {:context => "homepage", :id => how_tos(:rejected).slug, :selected_user => rmoore.slug  }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
    assert_select "a", {:text => "Back to articles", :count => 1  }
    assert_select "div[class=publication-actions]", :count => 1
  end

end