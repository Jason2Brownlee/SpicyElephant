class Subscription < ActiveRecord::Base
    
    xss_terminate :except => [ :transaction_details ]
    
    fields do
      start_subscription_at :date, :required
      timestamps
    end
    
  # associations
  belongs_to :user
  
  def self.create_lifetime_subscription(user, transaction_details)
    subscription = Subscription.new
    subscription.user = user
    subscription.start_subscription_at = Time.new
    subscription.end_subscription_at = Time.new
    subscription.transcation = transaction_details
    subscription.type = 'LIFE'
    subscription.save
    
    Permission.add_subscription_role(user);
  end
  
end
