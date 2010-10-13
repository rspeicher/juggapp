every 2.hours do
  rake 'applications:update'
end

every 1.week do
  rake 'severs:update'
end
