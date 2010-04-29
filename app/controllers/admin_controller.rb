class AdminController < ApplicationController
  before_filter :require_admin

  def show
    @applicants = Applicant.pending.all(:order => 'created_at DESC')
  end
end
