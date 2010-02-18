class ApplicantCharacter < ActiveRecord::Base
  WOW_CLASSES = (['Death Knight'] + %w(Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)).sort.freeze
  WOW_RACES   = (['Blood Elf', 'Night Elf'] + %w(Draenei Dwarf Gnome Human Orc Tauren Troll Undead)).sort.freeze

  validates_presence_of :current_name
  validates_presence_of :server
  validates_inclusion_of :current_race, :in => WOW_RACES,   :message => "{{value}} is not a valid race"
  validates_inclusion_of :wow_class,    :in => WOW_CLASSES, :message => "{{value}} is not a valid class"
  validates_presence_of :armory_link

  belongs_to :applicant
  belongs_to :server
end
