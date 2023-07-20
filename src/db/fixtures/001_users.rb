#
# Default users
# To add, execute: rake db:populate
#


# prepare an administrator role
if Role.find_by_rolename('administrator') == nil
  Role.create(:rolename => 'administrator')
end

# function for creating users safely
def self.create_user(name_s, email_s, role_s = nil)
  if User.find_by_login(name_s) == nil
    user = User.new
    user.login = name_s
    user.email = email_s
    user.password = name_s
    user.password_confirmation = name_s
    user.study_mode_id = 3
    user.save
    user.send(:activate!)
    print " > created user #{name_s}\n"
    if(role_s != nil)
      role = Role.find_by_rolename(role_s)
      user = User.find_by_login(name_s)
      permission = Permission.new
      permission.role = role
      permission.user = user
      permission.save
      print " > assigned role #{role_s} to user #{name_s}\n"
    end
  else
    print " > skipped user #{name_s}, already exists\n"
  end
end

# list of users
create_user("jasonb", "jason.brownlee05@gmail.com", "administrator")
create_user("craig", "craigbbaker@gmail.com", "administrator")
create_user("ctaylor", "camerontaylor@gmail.com", "administrator")
create_user("matt", "mr.mmilo@gmail.com", "administrator")
