Factory.define :applicant do |a|
  a.status 'new'
  a.user_id 1
  a.association :applicant_personal
  a.association :applicant_character
  a.association :applicant_system
end

Factory.define :applicant_character do |f|
  f.current_name 'Tsigo'
  f.current_race 'Undead'
  f.wow_class 'Priest'
  f.armory_link "http://www.wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo"
  f.association :server
end

Factory.define :applicant_personal do |f|
end

Factory.define :applicant_system do |f|
end

Factory.define :server do |f|
  f.region 'us'
  f.name "Mal'Ganis"
  f.ruleset 'pvp'
end