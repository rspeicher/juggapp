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


  # it { should allow_value("Mal'Ganis").for(:character_server) }
  # it { should_not allow_value('Invalid').for(:character_server) }
  # it { should allow_value("http://www.wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should allow_value("http://wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should_not allow_value("http://www.google.com/").for(:armory_link) }
end