class ReviewerController < ApplicationController

	def authorized?
		is_reviewer?
	end
  def index
		@articles = Article.reviewable
  end

  def reject
		get_article
		@article.rejected_at = Time.now.utc
		@article.rejected_by_id = current_user.id
		unless params[:reason_reject].nil?
			@article.reason_reject = params[:reason_reject]
		end
		@article.reject!
		redirect_back_or_default root_url
  end

  def approve
		get_article
		@article.approved_at = Time.now.utc
		@article.approved_by_id = current_user.id
		@article.save!
		redirect_back_or_default root_url
  end

	def get_article
				@article = Article.find(params[:article_id])
	end

end
