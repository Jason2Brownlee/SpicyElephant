class ActivitiesController < ApplicationController

  # current_tab :decks

  def index
    if !params[:id].nil?
      @user = User.find(params[:id])
      @activities = @user.activities.paginate(:all, :order => "created_at DESC", :page => params[:page])
    else
      @activities = Activity.paginate(:all, :order => "created_at DESC", :page => params[:page])
    end
  end

end
