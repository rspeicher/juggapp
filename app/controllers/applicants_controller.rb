class ApplicantsController < ApplicationController
  before_filter :require_user
  before_filter :find_parent

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
    @applicant = @parent.applicants.find(params[:id])

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
        # FIXME: Not getting an error message here
        wants.html { render :action => "new" }
      end
    end
  end

  def update
    @applicant = @parent.applicants.find(params[:id])

    respond_to do |wants|
      if @applicant.update_attributes(params[:applicant])
        flash[:success] = 'Application updated successfully.'
        wants.html { redirect_to root_path }
      else
        # FIXME: Not getting an error message here
        wants.html { render :action => 'edit' }
      end
    end
  end

  def post
    require 'xmlrpc/client'

    @applicant = @parent.applicants.find(params[:id])

    if @applicant.status == 'pending'
        if current_user.is_validating?
          flash[:error] = "You cannot post an application while your account is validating. Please confirm the e-mail validation first."
        else
          server = XMLRPC::Client.new2('http://www.juggernautguild.com/interface/board/')

          response = server.call('postTopic', {
            :api_module   => 'ipb',
            :api_key      => Juggernaut[:ipb_api_key],
            :member_field => 'id',
            :member_key   => current_user.id,
            :forum_id     => 10,
            :topic_title  => @applicant.to_s,
            :post_content => render_to_string(:layout => false)
          })

          flash[:success] = "Your application has been successfully posted for review."
        end
    else
      flash[:error] = "Only pending applications may be posted."
    end

    respond_to do |wants|
      wants.html { redirect_to root_path }
    end
  end

  protected
    def find_parent
      @parent = @user = current_user
    end
end
