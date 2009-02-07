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
    flash[:notice]="#{@item.class.to_s.titleize.downcase.capitalize} was rejected"
		redirect_back_or_default root_url
  end

  def approve
		get_item
		@item.approved_at = Time.now.utc
		@item.approved_by_id = current_user.id
		@item.save!
    flash[:notice]="#{@item.class.to_s.titleize.downcase.capitalize} was approved"
		redirect_back_or_default root_url
  end

	def get_item
    begin
      @item = Article.find(params[:article_id]) unless params[:article_id].nil?
    rescue ActiveRecord::RecordNotFound
      #do nothing
    end
    begin
      @item = HowTo.find(params[:how_to_id]) unless params[:how_to_id].nil?
    rescue ActiveRecord::RecordNotFound
      #do nothing
    end
    begin
      @item = UserProfile.find(params[:user_profile_id]) unless params[:user_profile_id].nil?
    rescue ActiveRecord::RecordNotFound
      #do nothing
    end

	end

end
