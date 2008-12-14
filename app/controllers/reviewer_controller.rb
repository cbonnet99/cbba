class ReviewerController < ApplicationController

	def authorized?
		is_reviewer?
	end
  def index
		@articles = Article.reviewable
		@user_profiles = UserProfile.reviewable
  end

  def reject
		get_item
		@item.rejected_at = Time.now.utc
		@item.rejected_by_id = current_user.id
		unless params[:reason_reject].nil?
			@item.reason_reject = params[:reason_reject]
		end
		@item.reject!
    UserMailer.deliver_item_rejected(@item, @item.author)
		redirect_back_or_default root_url
  end

  def approve
		get_item
		@item.approved_at = Time.now.utc
		@item.approved_by_id = current_user.id
		@item.save!
		redirect_back_or_default root_url
  end

	def get_item
		@item = Article.find(params[:article_id]) unless params[:article_id].nil?
		@item = UserProfile.find(params[:user_profile_id]) unless params[:user_profile_id].nil?
	end

end
