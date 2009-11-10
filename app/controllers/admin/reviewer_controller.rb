class Admin::ReviewerController < AdminApplicationController
  before_filter :set_context
  
  def index
		@articles = Article.reviewable
		@how_tos = HowTo.reviewable
		@special_offers = SpecialOffer.reviewable
		@gift_vouchers = GiftVoucher.reviewable
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
		redirect_to  reviewer_url(:action => "index")
  end

  def approve
		get_item
		@item.approved_at = Time.now.utc
		@item.approved_by_id = current_user.id
		@item.save!
    flash[:notice]="#{@item.class.to_s.titleize.downcase.capitalize} was approved"
		redirect_to reviewer_url(:action => "index")
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
    begin
      @item = SpecialOffer.find(params[:special_offer_id]) unless params[:special_offer_id].nil?
    rescue ActiveRecord::RecordNotFound
      #do nothing
    end
    begin
      @item = GiftVoucher.find(params[:gift_voucher_id]) unless params[:gift_voucher_id].nil?
    rescue ActiveRecord::RecordNotFound
      #do nothing
    end

	end

private
  def set_context
    @context = "review"
  end
end
