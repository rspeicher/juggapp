require 'spec_helper'

describe ApplicantsController, "routing" do
  it { should route(:get, '/applications'       ).to(:controller => :applicants, :action => :index) }
  # it { should route(:get, '/applications/1'     ).to(:controller => :applicants, :action => :show, :id => 1) }
  it { should route(:get, '/applications/new'   ).to(:controller => :applicants, :action => :new) }
  it { should route(:get, '/applications/1/edit').to(:controller => :applicants, :action => :edit, :id => 1) }
  it { should route(:post, '/applications'      ).to(:controller => :applicants, :action => :create) }
  it { should route(:put, '/applications/1'     ).to(:controller => :applicants, :action => :update, :id => 1) }
end

describe ApplicantsController, "GET index" do
  before(:each) do
    login(:user)
  end

  before(:each) do
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:applicants).with_kind_of(Array) }
  it { should render_template(:index) }
end

describe ApplicantsController, "GET new" do
  before(:each) do
    login(:user)
  end

  before(:each) do
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:applicant).with_kind_of(Applicant) }
  it { should render_template(:new) }
end

describe ApplicantsController, "GET edit" do
  before(:each) do
    login(:user)
    @app = Factory(:applicant)
    Applicant.expects(:find).with('1', anything()).returns(@app)
  end

  before(:each) do
    get :edit, :id => '1'
  end

  it { should respond_with(:success) }
  it { should assign_to(:applicant).with(@app) }
  it { should render_template(:edit) }
end

describe ApplicantsController, "POST create" do
  before(:each) do
    login(:user)
    @app = Factory(:applicant)
    Applicant.expects(:new).with({}).once.returns(@app)
  end

  context "success" do
    before(:each) do
      @app.expects(:save).returns(true)
      post :create, :applicant => {}
    end

    it { should set_the_flash.to(/submitted successfully/) }
    it { should redirect_to(applications_path) }
  end

  context "failure" do
    before(:each) do
      @app.expects(:save).returns(false)
      post :create, :applicant => {}
    end

    # it { should set_the_flash.to(/Application failed/) } # TODO: Error message?
    it { should render_template(:new) }
  end
end

describe ApplicantsController, "PUT update" do
  before(:each) do
    login(:user)
    @app = Factory(:applicant)
    Applicant.expects(:find).with('1', anything()).once.returns(@app)
  end

  context "success" do
    before(:each) do
      @app.expects(:update_attributes).returns(true)
      put :update, :id => '1', :applicant => {}
    end

    it { should set_the_flash.to(/updated successfully/) }
    it { should redirect_to(applications_path) }
  end

  context "failure" do
    before(:each) do
      @app.expects(:update_attributes).returns(false)
      put :update, :id => '1', :applicant => {}
    end

    # it { should set_the_flash.to(/Application failed/) } # TODO: Error message?
    it { should render_template(:edit) }
  end
end