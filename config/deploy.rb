set :application, "energie"
set :repo_url, "git@github.com:eckih/energie.git"
set :rails_env, 'production'
set :rbenv_type, :system
set :rbenv_ruby, "1.9.3-p0"
set :deplay_to, "/var/www/energie"
 
set :user, 'deploy'
set :password, nil
set :group, "deploy"

set :scm, :git
set :repository, "git@github.com:eckih/energie.git"
set :scm_username, "eckih"

set :location, ""
role :app, location
role :web, location
role :db, location, :primary => true
set :user, "ec2-user"
ssh_options[:keys] = ["/Users/eckih/.ssh/ec2.pem"]
default_run_options[:pty] = true

set :branch, 'master'
set :scm_verbose, true