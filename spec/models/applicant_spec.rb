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


  # it { should allow_value("http://www.wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should allow_value("http://wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should_not allow_value("http://www.google.com/").for(:armory_link) }
end

describe Applicant, "#posted!" do
  before(:each) do
    @applicant = Factory(:applicant)
  end

  it "should set the value for topic_id" do
    lambda { @applicant.posted!(12345) }.should change(@applicant, :topic_id).from(nil).to(12345)
  end

  it "should change the status to 'posted'" do
    lambda { @applicant.posted!(12345) }.should change(@applicant, :status).from('pending').to('posted')
  end

  it "should save the record" do
    @applicant.expects(:save)
    @applicant.posted!(12345)
  end

  it "should do nothing unless the application is pending" do
    @applicant.status = 'guilded'

    @applicant.expects(:save).never
    @applicant.posted!(12345)
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
