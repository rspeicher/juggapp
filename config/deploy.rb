set :stages, %w(production staging)
set :default_stage, 'production'
require 'capistrano/ext/multistage'

set :application, "juggapp"

set :use_sudo, false
set :keep_releases, 3

set :user, 'tsigo'
set :ssh_options, { :forward_agent => true, :keys => "/Users/tsigo/.ssh/id_rsa" }

namespace :deploy do
  desc "Start the server"
  task :start, :roles => :app do
    run "rm -f #{current_release}/tmp/stop.txt"
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Redirect to a 503 file (stop the server)"
  task :stop, :roles => :app do
    run "touch #{current_release}/tmp/stop.txt"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after "deploy:symlink", "deploy:database_yml"

namespace :deploy do
  desc "Copy database.yml file"
  task :database_yml, :roles => :db do
    run "cp #{shared_path}/config/database.yml #{current_release}/config/database.yml"
    run "cp #{shared_path}/config/juggernaut.yml #{current_release}/config/juggernaut.yml"
  end
end

# Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
#   $: << File.join(vendored_notifier, 'lib')
# end
#
# require 'hoptoad_notifier/capistrano'
