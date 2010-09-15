Factory.define :applicant do |f|
  f.status 'pending'
  f.user_id 1

  # Personal Info

  # Character Info
  f.character_name 'Tsigo'
  f.character_race 'Undead'
  f.character_class 'Priest'
  f.armory_link "http://www.wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo"
  f.association :server
end

Factory.define :server do |f|
  f.region 'us'
  f.sequence(:name) { |n| "Server #{n}" }
  f.ruleset 'pvp'
end

Factory.define :user, :default_strategy => :build do |f|
  f.name 'User'
  f.member_group_id 3
  f.persistence_token 'b18f1a5dc276001e6fe20139d5522755e414cdee'
end

Factory.define :admin, :parent => :user, :default_strategy => :build do |f|
  f.member_group_id 4
end

Factory.define :validating_user, :parent => :user, :default_strategy => :build do |f|
  f.member_group_id 1
end
