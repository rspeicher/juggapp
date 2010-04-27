namespace :servers do
  desc "Update World of Warcraft Servers"
  task :update => [:environment] do
    Server.create_from_armory
  end
end

namespace :applications do
  desc "Update application statuses via the forum"
  task :update => [:environment] do
    Topic.update_all
  end
end