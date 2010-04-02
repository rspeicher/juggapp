class Applicant < ActiveRecord::Base
  attr_protected :id, :status, :topic_id, :created_at, :updated_at

  named_scope :pending,  :conditions => { :status => 'pending' }
  named_scope :posted,   :conditions => { :status => 'posted' }
  named_scope :denied,   :conditions => { :status => 'denied' }
  named_scope :accepted, :conditions => { :status => 'accepted' }
  named_scope :guilded,  :conditions => { :status => 'guilded' }
  named_scope :waiting,  :conditions => { :status => 'waiting' }

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

  def to_s
    return '' unless self.character_name.present? and self.character_class.present? and self.created_at.present?

    "#{self.character_name} - #{self.character_class} - #{self.created_at.to_date.to_s(:db)}"
  end

  def posted!(topic_id)
    return unless self.status == 'pending'

    self.topic_id = topic_id
    self.status = 'posted'
    self.save
  end

  # Given a +Hash+ representing a response from +XMLRPC+, update the +status+ attribute depending on several factors.
  #
  # - A pinned topic in forum 6 (Applicant Review) is considered 'accepted'
  # - A topic in forum 21 (Archives) is considered 'guilded'
  # - A topic in forum 45 (Declined) is considered 'declined'
  # - A topic in forum 44 (Waiting) is considered 'waiting'
  def update_status_from_board!(response)
    return if self.status == 'pending'

    response.symbolize_keys!
    return unless response[:topic_id].present? and response[:topic_id].to_i == self.topic_id

    if response[:pinned].to_i == 1 and response[:forum_id].to_i == 6
      self.status = 'accepted'
    elsif response[:forum_id].to_i == 45
      self.status = 'denied'
    elsif response[:forum_id].to_i == 44
      self.status = 'waiting'
    elsif response[:forum_id].to_i == 21
      self.status = 'guilded'
    end

    self.save
  end
end