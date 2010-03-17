class Applicant < ActiveRecord::Base
  # Base
  validates_inclusion_of :status, :in => %w(pending posted denied accepted guilded waiting)
  validates_presence_of :user_id
  # validates_format_of :armory_link, :with => /^http:\/\/(www\.)?wowarmory\.com.+/, :message => 'is not a valid Armory link'

  belongs_to :user
  
  # Personal Info
  
  # Character Info
  WOW_CLASSES = (['Death Knight'] + %w(Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)).sort.freeze
  WOW_RACES   = (['Blood Elf', 'Night Elf'] + %w(Draenei Dwarf Gnome Human Orc Tauren Troll Undead)).sort.freeze

  validates_presence_of :character_name
  validates_presence_of :server
  validates_presence_of :character_race
  validates_inclusion_of :character_race, :in => WOW_RACES, :message => "{{value}} is not a valid race", :if => Proc.new { |c| c.character_race.present? }
  validates_presence_of :character_class
  validates_inclusion_of :character_class, :in => WOW_CLASSES, :message => "{{value}} is not a valid class", :if => Proc.new { |c| c.character_class.present? }
  validates_presence_of :armory_link

  belongs_to :server

  alias_method :current_server, :server
  
  # System Info
end