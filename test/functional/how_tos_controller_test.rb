require File.dirname(__FILE__) + '/../test_helper'

class HowTosControllerTest < ActionController::TestCase
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
    post :create, { :how_to =>
       {:step_label => "step", :title =>"Title here", :summary => "Summary now", :subcategory1_id => subcategories(:yoga).id,
        :new_step_attributes => [
          {:title =>"1st step", "body"=>"blabla"}]}}, {:user_id => cyrille.id }
    assert_not_nil assigns(:how_to)
    assert assigns(:how_to).errors.blank?
    assert_equal flash[:notice], "Your 'how to' article was successfully saved and published."
    assert_redirected_to how_tos_show_path(cyrille.slug, "title-here")
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

		post :publish, {:id => improve.id }, {:user_id => cyrille.id}
		assert_redirected_to how_tos_show_path(improve.author.slug, improve.slug)
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

		post :unpublish, {:id => money.id }, {:user_id => cyrille.id}
		assert_redirected_to how_tos_show_path(money.author.slug, money.slug)
		money.reload
		assert_nil money.published_at

    cyrille.reload
    assert_equal old_size-1, cyrille.published_how_tos_count
	end

  def test_show
    cyrille = users(:cyrille)
    get :show, {:id => how_tos(:money).slug, :selected_user => cyrille.slug  }, {:user_id => cyrille.id }
    assert_response :success
    assert_not_nil assigns(:selected_user)
    assert_not_nil assigns(:how_to)
  end

end