# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  include AuthenticatedSystem
  
  # use users's time zone
  before_filter :set_time_zone
  
  def set_time_zone
    Time.zone = current_user.time_zone if logged_in?
  end
  
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '6af2711cf102c537b9df5446460e2525'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  def order_by
    return {} if params[:order].blank?
    direction = params[:direction] || "ASC"
    logger.info params[:order]
    #return { :order => "#{params[:order]} #{direction}" }
    return "#{params[:order]} #{direction}"
  end
	
	
  # protection - only view deck is visible
  def check_deck_visibility(deck)
    unless deck.is_visible?(current_user)
      flash[:notice] = 'Sorry, you do not have permission to view this deck.'
      redirect_to root_path
    end
  end
  
  # protection - only manage deck if author
  def check_deck_author(deck)
    unless deck.is_author?(current_user)
      flash[:notice] = 'Sorry, you do not have permission to manage this deck.'
      redirect_to root_path
    end
  end

end
