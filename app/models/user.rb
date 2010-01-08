class User < InvisionBridge::User::Base
  ADMIN_GROUP     = 4
  MEMBER_GROUP    = 8
  APPLICANT_GROUP = 9

  def is_admin?
    self.member_group_id == ADMIN_GROUP
  end
end
