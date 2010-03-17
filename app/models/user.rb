class User < InvisionBridge::User::Base
  GROUP_VALIDATING = 1
  GROUP_ANONYMOUS  = 2
  GROUP_PEONS      = 3
  GROUP_OFFICERS   = 4
  GROUP_BANNED     = 5
  GROUP_MEMBERS    = 8
  GROUP_APPLICANTS = 9

  has_many :applicants

  def is_validated?
    self.member_group_id != GROUP_VALIDATING and self.member_group_id != GROUP_BANNED and self.member_group_id != GROUP_ANONYMOUS
  end

  def is_admin?
    self.member_group_id == GROUP_OFFICERS
  end
end
