require 'spec_helper'

describe ApplicantsController, "routing" do
  it { should route(:get,  '/applications'       ).to(:controller => :applicants, :action => :index) }
  it { should route(:get,  '/applications/new'   ).to(:controller => :applicants, :action => :new) }
  it { should route(:get,  '/applications/1/edit').to(:controller => :applicants, :action => :edit, :id => 1) }
  it { should route(:post, '/applications'       ).to(:controller => :applicants, :action => :create) }
  it { should route(:put,  '/applications/1'     ).to(:controller => :applicants, :action => :update, :id => 1) }
  it { should route(:post, '/applications/1/post').to(:controller => :applicants, :action => :post, :id => 1) }
end

describe ApplicantsController, "GET index" do
  before do
    login(:user)
    get :index
  end

  it { should respond_with(:success) }
  it { should assign_to(:applicants) }
  it { should render_template(:index) }
end

describe ApplicantsController, "GET new" do
  before do
    login(:user)
    get :new
  end

  it { should respond_with(:success) }
  it { should assign_to(:applicant).with_kind_of(Applicant) }
  it { should render_template(:new) }
end

describe ApplicantsController, "GET edit" do
  context "as a user who has an application" do
    before do
      login(:user)
      controller.stubs(:current_user).returns(mock(:is_admin? => false, :applicants => Applicant))
    end

    context "pending application" do
      before do
        @app = Factory(:applicant)
        get :edit, :id => @app
      end

      it { should respond_with(:success) }
      it { should assign_to(:applicant).with(@app) }
      it { should render_template(:edit) }
    end

    context "non-pending application" do
      before do
        @app = Factory(:applicant, :status => 'posted')
        get :edit, :id => @app
      end

      it { should set_the_flash.to(/has already been posted/) }
      it { should assign_to(:applicant).with(@app) }
      it { should render_template(:edit) }
    end
  end

  context "as an administrator" do
    before do
      login(:admin)
      @app = Factory(:applicant, :user_id => 999999999, :status => 'pending') # Hacky user_id
      get :edit, :id => @app
    end

    it { should respond_with(:success) }
    it { should assign_to(:applicant).with(@app) }
    it { should render_template(:edit) }
  end
end

describe ApplicantsController, "POST create" do
  before do
    login(:user)
    @app = Factory(:applicant)
    Applicant.expects(:new).with({}).once.returns(@app)
  end

  context "success" do
    before do
      @app.expects(:save).returns(true)
      post :create, :applicant => {}
    end

    it { should set_the_flash.to(/submitted successfully/) }
    it { should redirect_to(root_path) }
  end

  context "failure" do
    before do
      @app.expects(:save).returns(false)
      post :create, :applicant => {}
    end

    it { should set_the_flash.to(/problem with your application/) }
    it { should render_template(:new) }
  end
end

describe ApplicantsController, "PUT update" do
  before do
    login(:user)
    controller.stubs(:current_user).returns(mock(:is_admin? => false, :applicants => Applicant))
  end

  context "success" do
    before do
      Applicant.any_instance.expects(:update_attributes).with({}).returns(true)
      put :update, :id => Factory(:applicant), :applicant => {}
    end

    it { should set_the_flash.to(/updated successfully/) }
    it { should redirect_to(root_path) }
  end

  context "failure" do
    before do
      Applicant.any_instance.expects(:update_attributes).with({}).returns(false)
      put :update, :id => Factory(:applicant), :applicant => {}
    end

    it { should set_the_flash.to(/problem with your application/) }
    it { should render_template(:edit) }
  end
end

describe ApplicantsController, "POST post" do
  before do
    login(:user)
    controller.stubs(:current_user).returns(mock(:is_admin? => false, :applicants => Applicant))
    @app = Factory(:applicant)
  end

  context "with a pending application" do
    context "with one application already posted" do
      before do
        Applicant.any_instance.expects(:post).raises(ApplicationAlreadyPostedError)
        post :post, :id => @app
      end

      it { should set_the_flash.to(/cannot have more than one application posted at a time/) }
      it { should redirect_to(root_path) }
    end

    context "making successful RPC call" do
      before do
        Applicant.any_instance.expects(:post).returns(true)
        post :post, :id => @app
      end

      it { should set_the_flash.to(/successfully posted for review/) }
      it { should redirect_to(root_path) }
    end

    context "making unsuccessful RPC call" do
      before do
        Applicant.any_instance.expects(:post).raises(ApplicationGenericError)
        post :post, :id => @app
      end

      it { should set_the_flash.to(/could not be posted/) }
      it { should redirect_to(root_path) }
    end
  end

  context "with a non-pending application" do
    before do
      Applicant.any_instance.expects(:post).raises(ApplicationStatusError, "Only pending applications may be posted.")
      post :post, :id => @app
    end

    it { should set_the_flash.to("Only pending applications may be posted.") }
    it { should redirect_to(root_path) }
  end
end
