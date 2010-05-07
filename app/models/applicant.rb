# Raised when an application could not be posted for an unknown reason.
class ApplicationGenericError < RuntimeError
end

# Raised when attempting to post an application not marked as 'pending'
class ApplicationNotPending < RuntimeError
end

# Raised when attemping to post an application owned by a user who already has one posted.
class ApplicationAlreadyPosted < RuntimeError
end

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

  def to_s
    return '' unless self.character_name.present? and self.character_class.present? and self.created_at.present?

    "#{self.character_name} - #{self.character_class} - #{self.created_at.to_date.to_s(:db)}"
  end

  # Posts the application through IP.Board's XMLRPC interface
  #
  # Requires <tt>body</tt> to be passed in through the controller's <tt>render_to_string</tt> method.
  #
  # Raises:
  #   - ApplicationNotPending unless the application is pending
  #   - ApplicationAlreadyPosted if there is already an application from this user marked as 'posted'
  #   - ApplicationGenericError if the application could not be posted for some other reason
  def post(body)
    raise ApplicationNotPending unless self.status == 'pending'
    raise ApplicationAlreadyPosted unless self.class.count(:conditions => {:user_id => self.user_id, :status => 'posted'}) == 0

    require 'xmlrpc/client'
    server = XMLRPC::Client.new2('http://www.juggernautguild.com/interface/board/')

    response = server.call('postTopic', {
      :api_module   => 'ipb',
      :api_key      => Juggernaut[:ipb_api_key],
      :member_field => 'id',
      :member_key   => self.user_id,
      :forum_id     => 6,
      :topic_title  => self.to_s,
      :post_content => body
    })

    if response['result'].present? and response['result'] == 'success' and response['topic_id'].present?
      self.topic_id = response['topic_id'].to_i
      self.status = 'posted'
      self.save
    else
      raise ApplicationGenericError
    end

    return true
  end

  # Given a +Hash+ representing a response from +XMLRPC+, update the +status+ attribute depending on several factors.
  #
  # - A pinned topic in forum 6 (Applicant Review) is considered 'accepted'
  # - A topic in forum 21 (Archives) is considered 'guilded'
  # - A topic in forum 45 (Declined) is considered 'declined'
  # - A topic in forum 44 (Waiting) is considered 'waiting'
  # - 'pending' and 'posted' are controlled by the user and should not be updated here.
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
