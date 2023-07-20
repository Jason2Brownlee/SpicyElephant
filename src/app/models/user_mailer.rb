class UserMailer < ActionMailer::Base
  
  def recommend_message(recommend, deck, sender)
		@recipients = recommend.email_address
		@from = "'spicy elephant' <#{SUPPORT_EMAIL}>"		
		@subject = "Spicy Elephant - Recommendation from your friend #{sender.login}"
		@body['name'] = recommend.name
		@body['message'] = recommend.message
		@body['sender'] = sender
		@body['deck'] = deck
	end
  
  def signup_notification(user)
    setup_email(user)
    @subject    += ' - Please activate your new account'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user )
    @subject    += ' - Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def forgot_password(user)
    setup_email(user)
    @subject    += ' - You have requested to change your password'
    @body[:url]  = "http://#{SITE_URL}/reset_password/#{user.password_reset_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += ' - Your password has been reset.'
  end
  
  def scheduled_notification(user, cards_review_count, message_count)
    setup_email(user)
    if cards_review_count > 0
      @subject    += " - You have #{cards_review_count} scheduled cards to study."
    else
      @subject    += " - You have new messages."
    end
    @body[:train_url]  = "http://#{SITE_URL}/train/"
    @body[:cards_review_count] = cards_review_count
    @body[:unsubscribe_url] = "http://#{SITE_URL}/users/#{user.id}/emailNotification"
    @body[:message_count] = message_count
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from = "'spicy elephant' <#{SUPPORT_EMAIL}>"	
      @subject     = "Spicy Elephant"
      @sent_on     = Time.now
      @body[:user] = user
    end
end

