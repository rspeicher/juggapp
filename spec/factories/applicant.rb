require 'faker'

Factory.define :applicant do |a|
  a.character_name Faker::Internet.user_name
end