require 'spec_helper'

describe Server do
  before do
    @server = Factory(:server)
  end

  it "should be valid" do
    @server.should be_valid
  end

  context "mass assignment" do
    it { should_not allow_mass_assignment_of(:id) }
    it { should allow_mass_assignment_of(:region) }
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:ruleset) }
  end

  context "validations" do
    it { should allow_value('us').for(:region) }
    it { should allow_value('eu').for(:region) }
    it { should_not allow_value('invalid').for(:region) }
    it { should validate_presence_of(:region) }

    it { should validate_presence_of(:name) }

    it { should allow_value('pve').for(:ruleset) }
    it { should allow_value('pvp').for(:ruleset) }
    it { should allow_value('rp').for(:ruleset) }
    it { should allow_value('rppvp').for(:ruleset) }
    it { should validate_presence_of(:ruleset) }

    it { should validate_uniqueness_of(:name).scoped_to(:region) }
  end

  context "associations" do
  end
end

describe Server, "normalize_attributes callback" do
  it "should downcase +region+ before save" do
    Factory(:server, :region => 'EU').region.should eql('eu')
  end

  it "should downcase +type+ before save" do
    Factory(:server, :ruleset => 'RP').ruleset.should eql('rp')
  end
end

describe Server, ".create_from_armory" do
  before do
    FakeWeb.register_uri(:get, 'http://www.worldofwarcraft.com/realmstatus/index.xml', :body => file_fixture('realm_status.xml'))
  end

  it "should create new Server records" do
    Server.any_instance.expects(:save!).times(3)
    Server.create_from_armory
  end

  it "should correctly populate Server attributes" do
    Server.create_from_armory
    server = Server.first
    server.name.should eql('Aerie Peak')
    server.region.should eql('us')
    server.ruleset.should eql('pve')
  end

  it "should not create existing Server records" do
    Factory(:server, :name => 'Aerie Peak', :region => 'us', :ruleset => 'pve')
    lambda { Server.create_from_armory }.should change(Server, :count).from(1).to(3)
  end
end
