require 'spec_helper'

describe Applicant do
  before(:each) do
    UserSession.stubs(:find).returns(stub(:id => 1))
    @applicant = Factory(:applicant)
  end

  it "should be valid" do
    @applicant.should be_valid
  end

  it "should have a custom to_s" do
    @applicant.to_s.should eql("#{@applicant.character_name} - #{@applicant.character_class} - #{@applicant.created_at.to_date.to_s(:db)}")
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should_not allow_mass_assignment_of(:status) }
    it { should allow_mass_assignment_of(:user_id) }
    it { should_not allow_mass_assignment_of(:topic_id) }
    it { should_not allow_mass_assignment_of(:created_at) }
    it { should_not allow_mass_assignment_of(:updated_at) }
  end

  context "validations" do
    it { should allow_value('pending').for(:status) }
    it { should allow_value('posted').for(:status) }
    it { should allow_value('denied').for(:status) }
    it { should allow_value('accepted').for(:status) }
    it { should allow_value('guilded').for(:status) }
    it { should allow_value('waiting').for(:status) }
    it { should_not allow_value('invalid').for(:status) }

    it { should validate_presence_of(:user_id) }

    # Personal Info

    # Character Info
    it { should validate_presence_of(:character_name) }
    it { should validate_presence_of(:server) }
    it { should validate_presence_of(:character_race) }
    it { should validate_presence_of(:character_class) }
    it { should allow_value('Priest').for(:character_class) }
    it { should_not allow_value('Invalid').for(:character_class) }
    it { should allow_value('Undead').for(:character_race) }
    it { should_not allow_value('Invalid').for(:character_race) }
    it { should validate_presence_of(:armory_link) }

    # System Info
  end

  context "associations" do
    it { should belong_to(:user) }
  end

  # FIXME: Deprecated by Shoulda?
  # it { should have_named_scope(:pending) }
  # it { should have_named_scope(:posted) }
  # it { should have_named_scope(:denied) }
  # it { should have_named_scope(:accepted) }
  # it { should have_named_scope(:guilded) }
  # it { should have_named_scope(:waiting) }

  # it { should allow_value("http://www.wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should allow_value("http://wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should_not allow_value("http://www.google.com/").for(:armory_link) }
end

describe Applicant, "#post" do
  before(:each) do
    require 'xmlrpc/client'

    @applicant = Factory(:applicant)
  end

  it "should require a 'body' arugment" do
    lambda { @applicant.post }.should raise_error(ArgumentError)
  end

  it "should raise ApplicationNotPending unless application is pending" do
    @applicant.status = 'posted'
    lambda { @applicant.post('body') }.should raise_error(ApplicationNotPending)
  end

  it "should raise ApplicationAlreadyPosted if user already has a posted application" do
    Factory(:applicant, :user_id => @applicant.user_id, :status => 'posted')
    lambda { @applicant.post('body') }.should raise_error(ApplicationAlreadyPosted)
  end

  context "making successful call" do
    before(:each) do
      server = mock()
      server.expects(:call).with('postTopic', anything()).returns({"result" => "success", "topic_id" => 12345})
      XMLRPC::Client.stubs(:new2).returns(server)
    end

    it "should change status to 'posted'" do
      lambda { @applicant.post('body') }.should change(@applicant, :status).from('pending').to('posted')
    end

    it "should topic_id from nil to 12345" do
      lambda { @applicant.post('body') }.should change(@applicant, :topic_id).from(nil).to(12345)
    end
  end

  context "making unsuccessful call" do
    before(:each) do
      server = mock()
      server.expects(:call).with('postTopic', anything()).returns({}) # TODO: Find real failure response
      XMLRPC::Client.stubs(:new2).returns(server)
    end

    it "should raise ApplicationGenericError" do
      lambda { @applicant.post('body') }.should raise_error(ApplicationGenericError)
    end
  end
end

describe Applicant, "#update_status_from_board!" do
  include XMLRPCHelper

  def check_status(response_name, status_before, status_after)
    applicant = Factory(:applicant, :status => status_before, :topic_id => 12345)
    response = XMLRPCHelper::Response[response_name][0]

    lambda { applicant.update_status_from_board!(response) }.should change(applicant, :status).from(status_before).to(status_after)
  end

  it "should return nil if the application hasn't yet been posted" do
    Factory(:applicant, :status => 'pending', :topic_id => 12345).update_status_from_board!({'topic_id' => '12345'}).should be_nil
  end

  it "should return nil if the topic_id doesn't match the application's topic_id" do
    Factory(:applicant, :status => 'posted', :topic_id => 12345).update_status_from_board!({'topic_id' => '1'}).should be_nil
  end

  it "should change an app from 'posted' to 'accepted' if the topic is pinned" do
    check_status(:fetchTopics_review, 'posted', 'accepted')
  end

  it "should change an app from 'posted' to 'denied' if the topic is in the Declined forum" do
    check_status(:fetchTopics_declined, 'posted', 'denied')
  end

  it "should change an app from 'posted' to 'waiting' if the topic is in the Waiting forum" do
    check_status(:fetchTopics_waiting, 'posted', 'waiting')
  end

  it "should change an app from 'accepted' to 'guilded' if the topic is in the Archive forum" do
    check_status(:fetchTopics_archives, 'accepted', 'guilded')
  end
end

describe Applicant, "time parsing" do
  def format_time(time)
    time.strftime("%H:%M")
  end

  before(:each) do
    @applicant = Factory(:applicant)
  end

  it "should parse '1:30 pm'" do
    @applicant.start_monday = '1:30 pm'
    format_time(@applicant.start_monday).should eql('13:30')
  end

  it "should parse '10:25 AM'" do
    @applicant.start_monday = '10:25 AM'
    format_time(@applicant.start_monday).should eql('10:25')
  end

  it "should parse '4-5am'" do
    @applicant.start_monday = '4-5am'
    format_time(@applicant.start_monday).should satisfy { |v|
      (v == '04:00') or (v == '05:00') # Not sure I care which, if they enter something this stupid.
    }
  end

  it "should parse '4pm'" do
    @applicant.start_monday = '4pm'
    format_time(@applicant.start_monday).should eql('16:00')
  end

  # Invalid values parse to 00:00. Maybe that's ok?
  # it "should not parse 'whenever'" do
  #   @applicant.start_monday = 'whenever'
  #   format_time(@applicant.start_monday).should be_nil
  # end
end
