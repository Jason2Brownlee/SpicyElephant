class AddSubscribedRoleAndAssignToAll < ActiveRecord::Migration
  def self.up
    
    role_name = 'subscribed'
    
    # create role subscribed
    if Role.find_by_rolename(role_name) == nil
      Role.create(:rolename => role_name)
    end
    
    # get the role
    #role = Role.find_by_rolename(role_name)
    
    # assign to all current users
    # for user in User.find(:all)
    #       # create permission
    #       permission = user.permissions.build(:role => role)
    #       permission.save!
    #     end
    
  end

  def self.down
  end
end
