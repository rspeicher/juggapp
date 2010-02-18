class Applicant < ActiveRecord::Base
  validates_inclusion_of :status, :in => %w(new denied accepted guilded waiting)
  # validates_presence_of :user_id
  # validates_format_of :armory_link, :with => /^http:\/\/(www\.)?wowarmory\.com.+/, :message => 'is not a valid Armory link'

  belongs_to :user
  has_one :applicant_personal, :dependent => :destroy
  has_one :applicant_character, :dependent => :destroy
  has_one :applicant_system, :dependent => :destroy

  alias_method :personal_info, :applicant_personal
  alias_method :character_info, :applicant_character
  alias_method :system_info, :applicant_system

  accepts_nested_attributes_for :applicant_personal, :applicant_character, :applicant_system

  # protected
  #   def before_validation
  #     current_user = UserSession.find
  #     self.user_id = current_user.id unless current_user.blank?
  #   end
end