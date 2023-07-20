class HomeController < ApplicationController
  
  def index
    # pass through
  end
  
  def terms
    # pass through
  end
  
  def privacy
    # pass through
  end
  
  def feedback
    @feedback = Feedback.new
    if logged_in?
      @feedback.email_address = current_user.email
    end
  end
  
  def send_feedback_request
    @feedback = Feedback.new(params['feedback'])
    if @feedback.save
      begin
      FeedbackMailer::deliver_feedback_message(@feedback)
      flash[:notice] = "Thank you, we appreciate your feedback."
      # redirect to home page
      redirect_to root_path
      rescue
      flash[:notice] = "There was a problem sending the message"
      render :action => "feedback"
    end
    else
      render :action=>"feedback"
    end
  end

  
end
