class Server < ActiveRecord::Base
  RULESETS = %w(pve pvp rp rppvp).freeze
  REGIONS = %w(us eu).freeze

  attr_accessible :region, :name, :ruleset

  validates_presence_of :region
  validates_presence_of :name
  validates_presence_of :ruleset
  validates_inclusion_of :region, :in => REGIONS, :message => "{{value}} is not a valid region."
  validates_inclusion_of :ruleset, :in => RULESETS, :message => "{{value}} is not a valid ruleset."
  validates_uniqueness_of :name, :scope => :region

  def self.create_from_armory
    require 'open-uri'
    require 'nokogiri'

    current_servers = Server.all.inject([]) { |memo, server| memo << "#{server.region}-#{server.name.downcase}" }

    doc = Nokogiri::XML(open("http://www.worldofwarcraft.com/realmstatus/index.xml"))
    doc.search('rss/channel/item').each do |item|
      server = Server.new
      server.region = 'us'

      title = item.search('title').first.content
      if title =~ /^(.+) \(([^\s]+)\) Realm .+$/
        server.name = $1
        server.ruleset = $2
      end

      server.save! unless current_servers.include? "#{server.region.downcase}-#{server.name.downcase}"
    end
  end

  protected
    def before_validation
      self.region = self.region.downcase unless self.region.blank?
      self.ruleset = self.ruleset.downcase unless self.ruleset.blank?
    end
end
