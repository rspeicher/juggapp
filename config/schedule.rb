every 2.hours do
  runner "Topic.update_all"
end

every 1.week do
  runner "Server.create_from_armory"
end
