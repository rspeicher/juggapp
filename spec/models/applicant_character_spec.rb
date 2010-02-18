require 'spec_helper'

describe ApplicantCharacter do
  before(:each) do
    @character = Factory(:applicant_character)
  end

  it "should be valid" do
    @character.should be_valid
  end

  context "mass assignment" do

  end

  context "validations" do
    it { should validate_presence_of(:current_name) }
    it { should validate_presence_of(:server) }
    it { should allow_value('Priest').for(:wow_class) }
    it { should_not allow_value('Invalid').for(:wow_class) }
    it { should allow_value('Undead').for(:current_race) }
    it { should_not allow_value('Invalid').for(:current_race) }
    it { should validate_presence_of(:armory_link) }
  end

  context "associations" do
    it { should belong_to(:applicant) }
  end
end
