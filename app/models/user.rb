class User < ActiveRecord::Base
  include InvisionBridge

  GROUP_VALIDATING = 1
  GROUP_ANONYMOUS  = 2
  GROUP_PEONS      = 3
  GROUP_OFFICERS   = 4
  GROUP_BANNED     = 5
  GROUP_MEMBERS    = 8
  GROUP_APPLICANTS = 9

  has_many :applicants

  def is_validating?
    self.member_group_id == GROUP_VALIDATING
  end

  def is_admin?
    self.member_group_id == GROUP_OFFICERS
  end
end
