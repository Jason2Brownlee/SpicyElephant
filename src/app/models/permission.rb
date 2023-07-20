class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  
  # add subscribed role if it doesn't already exist
  def self.add_subscription_role(user)
    role = Role.find_by_rolename('subscribed')
    permission = Permission.find(:first, :conditions => {:user_id => user, :role_id => role})
    if permission == nil
      perm = Permission.new
      perm.role = role
      perm.user = user
      perm.save
    end
  end
end
