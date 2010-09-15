# = ControllerHelper
#
# Adds default behavior shared between specs for Controllers.
#
# == Behavior Added
#
# - Sets <tt>controller</tt> as the current <tt>subject</tt>, so that Shoulda's matchers
#   behave as expected.
module ControllerHelper
  def self.included(base)
    base.class_eval do
      subject { controller }
    end
  end
end
