namespace :servers do
  desc "Update World of Warcraft Servers"
  task :update => [:environment] do
    Server.create_from_armory
  end
end
