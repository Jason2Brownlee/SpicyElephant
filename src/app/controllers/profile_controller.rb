class ProfileController < ApplicationController
  
  # load the user for which the profile is displayed
  before_filter :load_user
  # force the profile tab
  # current_tab :profile
  
  # display a user's profile
  def index
  end
  
  # display user statistics
  def stats
  end



  private
  
  def load_user
    # check for a direct call without user specified
    # if logged in, push to current profile
    if params[:user].nil? && logged_in?
      @user = current_user
      @view_self = true
    else
      # try and load user
      @user = User.find(params[:user])
      # redirect if the user tries to hit spicy
      redirect_to root_path if @user.login == DEFAULT_USER_NAME
      # check if loaded user is self
      if logged_in? && (@user.id==current_user.id)
        @view_self = true
      end
    end
  end
  
end
