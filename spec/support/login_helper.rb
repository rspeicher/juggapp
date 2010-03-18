require 'authlogic'
require 'authlogic/test_case'

module LoginHelper
  include Authlogic::TestCase

  def login(type = :user, args = {})
    unless type == :guest
      activate_authlogic
      UserSession.create(Factory(type))
    end
  end
end
