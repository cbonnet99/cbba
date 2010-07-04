class StoredTokensController < ApplicationController
  before_filter :login_required
  filter_parameter_logging :card_number

  def edit
    @token = current_user.stored_tokens.find(params[:id])
    @token.card_number = @token.obfuscated_card_number
  end

  def update
  end
  
  def destroy
    @token = current_user.stored_tokens.find(params[:id])
    if @token.nil?
      flash[:error] = "Could not find this credit card"
    else
      @token.destroy
      flash[:notice] = "This credit card has been deleted"
    end
    redirect_to payments_url
  end
  
  def new
    @token = StoredToken.new(:first_name => current_user.first_name, :last_name => current_user.last_name)
  end
  
  def create
    @token = StoredToken.new(params[:stored_token])
    @token.user = current_user
    if @token.save
      flash[:notice] = "Your credit card was saved"
      redirect_to payments_url
    else
      flash[:error] = "Error while saving your credit card"
      render :action => "new" 
    end
  end

end
