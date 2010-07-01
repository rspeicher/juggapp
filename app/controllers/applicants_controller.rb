class ApplicantsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent
  before_filter :find_applicant, :only => [:edit, :update, :post]

  def index
    @applicants = @parent.applicants.find(:all, :order => 'updated_at DESC')

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
    unless @applicant.status == 'pending'
      flash.now[:error] = "This application has already been posted for review. Changes made here will not be reflected on the posted application."
    end

    respond_to do |wants|
      wants.html
    end
  end

  def create
    @applicant = @parent.applicants.new(params[:applicant])

    respond_to do |wants|
      if @applicant.save
        flash[:message] = 'Application submitted successfully.'
        wants.html { redirect_to root_path }
      else
        flash.now[:error] = "There was a problem with your application. Please see the error messages below."
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |wants|
      if @applicant.update_attributes(params[:applicant])
        flash[:success] = 'Application updated successfully.'
        wants.html { redirect_to root_path }
      else
        flash.now[:error] = "There was a problem with your application. Please see the error messages below."
        wants.html { render :action => 'edit' }
      end
    end
  end

  def post
    begin
      @applicant.post(render_to_string(:layout => false))
      flash[:success] = "Your application has been successfully posted for review."
    rescue ApplicationGenericError, ApplicationStatusError, ApplicationAlreadyPostedError => e
      flash[:error] = e.message
    ensure
      # FIXME: Redirects back to root even though sometimes we want to redirect back to admin
      respond_to do |wants|
        wants.html { redirect_to root_path }
      end
    end
  end

  protected
    def find_parent
      @parent = @user = current_user
    end

    def find_applicant
      if current_user.is_admin?
        @applicant = Applicant.find(params[:id])
      else
        @applicant = @parent.applicants.find(params[:id])
      end
    end
end
