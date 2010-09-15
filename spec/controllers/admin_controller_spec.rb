require 'spec_helper'

describe AdminController, "routing" do
  it { should route(:get, '/admin').to(:controller => :admin, :action => :show) }
end

describe AdminController, "GET show" do
  before do
    login(:admin)
    get :show
  end

  it { should respond_with(:success) }
  it { should assign_to(:applicants).with_kind_of(Array) }
  it { should render_template(:show) }
end
