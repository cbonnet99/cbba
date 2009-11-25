class OrdersController < ApplicationController
  def create
    @order = Order.new(params[:order])
    @order.user_id = current_user.id
    if @order.save
      redirect_to payment_action_with_id_url(@order.payment.id, :action => "edit")
    else
      flash[:error] = "Please select one of the features"
      redirect_to user_promote_url
    end
  end
  def update
    @order = current_user.orders.pending.first
    if @order.update_attributes(params[:order])
      redirect_to payment_action_with_id_url(@order.payment.id, :action => "edit")
    else
      flash[:error] = "Please select one of the features"
      redirect_to user_promote_url
    end
  end
end
