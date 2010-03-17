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

  # System Info
end

Factory.define :server do |f|
  f.region 'us'
  f.name "Mal'Ganis"
  f.ruleset 'pvp'
end