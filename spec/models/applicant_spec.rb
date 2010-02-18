require 'spec_helper'

describe Applicant do
  before(:each) do
    UserSession.stubs(:find).returns(stub(:id => 1))
    @applicant = Factory(:applicant)
  end

  it "should be valid" do
    @applicant.should be_valid
  end

  context "mass assignment" do
  end

  context "validations" do
    it { should allow_value('new').for(:status) }
    it { should allow_value('denied').for(:status) }
    it { should allow_value('accepted').for(:status) }
    it { should allow_value('guilded').for(:status) }
    it { should allow_value('waiting').for(:status) }
    it { should_not allow_value('invalid').for(:status) }

    # it { should validate_presence_of(:user_id) }
  end

  context "associations" do
    it { should belong_to(:user) }
    it { should have_one(:applicant_personal).dependent(:destroy) }
    it { should have_one(:applicant_character).dependent(:destroy) }
    it { should have_one(:applicant_system).dependent(:destroy) }
  end


  # it { should allow_value("Mal'Ganis").for(:character_server) }
  # it { should_not allow_value('Invalid').for(:character_server) }
  # it { should allow_value("http://www.wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should allow_value("http://wowarmory.com/character-sheet.xml?r=Mal%27Ganis&n=Tsigo").for(:armory_link) }
  # it { should_not allow_value("http://www.google.com/").for(:armory_link) }
end