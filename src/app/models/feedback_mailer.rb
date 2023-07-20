class FeedbackMailer < ActionMailer::Base

	def feedback_message(feedback)
		@recipients = FEEDBACK_RECIPIENT
		@from = feedback.email_address
		@subject = "#{SITE_URL} - Feedback"
		@body['name'] = feedback.name
		@body['email'] = feedback.email_address
		@body['message'] = feedback.message
	end  

end
