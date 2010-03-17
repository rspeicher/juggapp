class ApplicantsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent

  def index
    @applications = @parent.applicants.find(:all, :order => 'updated_at DESC')

    respond_to do |wants|
      wants.html
    end
  end

  def new
    @applicant = @parent.applicants.new

    respond_to do |wants|
      wants.html
    end
  end

  def edit
    @applicant = @parent.applicants.find(params[:id])

    respond_to do |wants|
      wants.html
    end
  end

  def create
    @applicant = @parent.applicants.new(params[:applicant])

    respond_to do |wants|
      if @applicant.save
        flash[:message] = 'Application submitted successfully.'
        wants.html { redirect_to applications_path }
      else
        flash[:error] = 'Application failed, please see errors below.'
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    @applicant = @parent.applicants.find(params[:id])

    respond_to do |wants|
      if @applicant.update_attributes(params[:applicant])
        flash[:success] = 'Application updated successfully.'
        wants.html { redirect_to applications_path }
      else
        flash[:error] = 'Application could not be updated, please see errors below.'
        wants.html { render :action => 'edit' }
      end
    end
  end

  protected
    def find_parent
      @parent = @user = current_user
    end
end
