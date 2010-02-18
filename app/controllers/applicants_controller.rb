class ApplicantsController < ApplicationController
  before_filter :require_user

  def index
    if current_user.is_admin?
      @applications = Applicant.find(:all, :order => 'updated_at DESC')
    else
      @applications = current_user.applications.find(:all, :order => 'updated_at DESC')
    end

    respond_to do |wants|
      wants.html
    end
  end

  def new
    @applicant = Applicant.new
    @personal_info = ApplicantPersonal.new
    @character_info = ApplicantCharacter.new
    @system_info = ApplicantSystem.new

    respond_to do |wants|
      wants.html
    end
  end

  def edit
    @applicant = Applicant.find(params[:id])

    respond_to do |wants|
      wants.html
    end
  end

  def create
    @applicant = Applicant.new(params[:applicant])

    respond_to do |wants|
      if @applicant.save
        flash[:message] = 'Application submitted successfully.'
        wants.html { redirect_to applications_path(@applicant) }
      else
        flash[:error] = 'Application failed, please see errors below.'
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    @applicant = Applicant.find(params[:id])

    respond_to do |wants|
      if @applicant.update_attributes(params[:applicant])
        flash[:success] = 'Application updated successfully.'
        wants.html { redirect_to applications_path }
      else
        wants.html { render :action => 'edit' }
      end
    end
  end
end
