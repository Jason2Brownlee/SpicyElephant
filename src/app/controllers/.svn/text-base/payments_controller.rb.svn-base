class PaymentsController < ApplicationController
    include ActiveMerchant::Billing
    
  before_filter :login_required, :only => [:index, :checkout, :confirm, :complete]
  before_filter :subscribed_check , :only => [:index, :checkout, :confirm, :complete]

  def subscribed_check
    if current_user.has_subscribed_role?
      redirect_to root_path
    end
  end


  def checkout
    setup_response = gateway.setup_purchase(2000,
      :ip                => request.remote_ip,
      :email             => current_user.email,
      :customer          => current_user.login,
      :no_shipping       => 1,
      :description       => 'Life Time Premium Subscription',
      :return_url        => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def index
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]
    
    details_response = gateway.details_for(params[:token])
    
    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end
      
    @address = details_response.address
  end

  def complete
    purchase = gateway.purchase(2000,
      :ip       => request.remote_ip,
      :payer_id => params[:payer_id],
      :token    => params[:token]
    )
    
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
    
    
    Subscription.create_lifetime_subscription(current_user, 'payerid:' + params[:payer_id] + ", token:" + params[:token])
  end

  private
  def gateway
    @gateway ||= PaypalExpressGateway.new(
      :login => PAYPAL_LOGIN,
      :password => PAYPAL_PASSWORD,
      :signature => PAYPAL_SIGN
    )
  end

end
