class UsersController < ApplicationController

  before_filter :not_logged_in_required, :only => [:new, :create] 
  before_filter :login_required, :only => [:edit, :update, :show, :change_time_zone]
  before_filter :check_administrator_role, :only => [:index, :destroy, :enable]

  def emailNotification
    if logged_in?
      redirect_to edit_user_path(current_user)
    else
      # render
    end
  end
    
  def index
    if params[:premium] == "true"
      @users = User.paginate :all, :conditions=>["roles.rolename=?","subscribed"], :include=>:roles, :page => params[:page]
    else
      @users = User.paginate :all, :page => params[:page]
    end
  end
  
  #This show action only allows users to view their own profile
  def show
    @user = current_user
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def create
    # check T&C selected
    params[:user]
    
    cookies.delete :auth_token
    @user = User.new(params[:user])
    @user.study_mode = StudyMode.supermemo_mode
    @user.save!
    #Uncomment to have the user logged in after creating an account - Not Recommended
    #self.current_user = @user
    
    # give all new users the default deck
    def_deck = Deck.default_about_deck
    @user.add_deck_to_curriculum?(def_deck)
    # prep their states
    SupermemoState.init(@user, def_deck)

    flash[:notice] = "Thanks for signing up! Please check your email to activate your account before logging in."
    redirect_to login_path    
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "There was a problem creating your account."
    render :action => 'new'
  end
  
  def edit
    @user = User.find(current_user)
  end
  
  def update
   @user = User.find(current_user)
   if @user.update_attributes(params[:user])
     flash[:notice] = "Settings updated"
     redirect_to :action => 'show', :id => current_user
   else
     render :action => 'edit'
   end
  end
  
  def destroy
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, false)
      flash[:notice] = "User disabled"
    else
      flash[:error] = "There was a problem disabling this user."
    end
    redirect_to :action => 'index'
  end
  
  def enable
    @user = User.find(params[:id])
    if @user.update_attribute(:enabled, true)
      flash[:notice] = "User enabled"
    else
      flash[:error] = "There was a problem enabling this user."
    end
    redirect_to :action => 'index'
  end
  
end
