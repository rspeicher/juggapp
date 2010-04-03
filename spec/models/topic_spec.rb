require 'spec_helper'

describe Topic, "fetch_topics" do
  before(:each) do
    require 'xmlrpc/client'

    server = mock()
    server.expects(:call).with('fetchTopics', anything()).returns(['Response'])
    XMLRPC::Client.stubs(:new2).returns(server)
  end

  # TODO: How do we spec this?
  # it "should yield a block if given"

  it "should return an array if no block given" do
    Topic.fetch_topics('1').should eql(['Response'])
  end
end

describe Topic, ".update_status" do
  include XMLRPCHelper

  before(:each) do
    @response = XMLRPCHelper::Response[:fetchTopics_review][0]

    @applicant = Factory(:applicant, :topic_id => 12345)
    Applicant.expects(:find).with(:first, anything()).returns(@applicant)
    Applicant.any_instance.expects(:update_status_from_board!).with(@response).returns(true)
  end

  it "should call Applicant#update_status_from_board!" do
    Topic.update_status(@response)
  end
end
