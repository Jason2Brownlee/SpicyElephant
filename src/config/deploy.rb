require 'deprec'

set :database_yml_in_scm, false
  
set :user, "ctaylor"
set :application, "retain"
set :domain, "209.20.77.39"
set :repository,  "http://mayhemsvn.svn.beanstalkapp.com/retain/trunk"
set :scm_user, "ctaylor"
set :scm_password, "mayhemmXOTmz"
set :gems_for_project, %w(ruby-openid) # list of gems to be installed

# Update these if you're not running everything on one host.
role :app, domain
role :web, domain
role :db,  domain, :primary => true
#role :scm, domain # used by deprec if you want to install subversion

# If you aren't deploying to /var/www/apps/#{application} on the target
# servers (which is the deprec default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    top.deprec.mongrel.restart
  end

db_params = {
  "adapter"=>"mysql",
  "database"=>"#{application}_#{rails_env}",
  "username"=>"root",
  "password"=>"",
  "host"=>"localhost",
  "socket"=>""
}

db_params.each do |param, default_val|
  set "db_#{param}".to_sym,
    lambda { Capistrano::CLI.ui.ask "Enter database #{param}" do |q| q.default=default_val end}
end

task :my_generate_database_yml, :roles => :app do
  database_configuration = "#{rails_env}:\n"
  db_params.each do |param, default_val|
    val=self.send("db_#{param}")
    database_configuration<<"  #{param}: #{val}\n"
  end
  run "mkdir -p #{deploy_to}/#{shared_dir}/config"
  put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml"
end

end
