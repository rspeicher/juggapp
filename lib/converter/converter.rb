require 'rubygems'
require 'dm-core'

require File.expand_path(File.join(File.dirname(__FILE__),'..','..','config','environment'))

DataMapper.setup(:default, 'mysql://localhost/juggernaut_forum_development')

class OldApplicant
  include DataMapper::Resource

  storage_names[:default] = 'juggapp2'

  property :app_id, Serial
  property :app_mid, Integer
  property :app_subdate, DateTime
  property :app_status, String
  property :app_thread, Integer

  property :personal_name, String
  property :personal_age, Integer
  property :personal_timezone, String
  property :personal_hourssu1, String
  property :personal_hourssu2, String
  property :personal_hoursmo1, String
  property :personal_hoursmo2, String
  property :personal_hourstu1, String
  property :personal_hourstu2, String
  property :personal_hourswe1, String
  property :personal_hourswe2, String
  property :personal_hoursth1, String
  property :personal_hoursth2, String
  property :personal_hoursfr1, String
  property :personal_hoursfr2, String
  property :personal_hourssa1, String
  property :personal_hourssa2, String
  property :personal_members, Text
  property :personal_experience, Text
  property :personal_commitments, Text
  property :personal_reasons, Text

  property :char_name, String
  property :char_class, String
  property :char_race, String
  property :char_profile, String

  property :wow_guilds, Text
  property :wow_reasonleft, Text
  property :wow_pve, Text
  property :wow_pvp, Text

  property :sys_connection, String
  property :sys_mic, Boolean
  property :sys_vent, Boolean
  property :sys_talk, Boolean

  property :comments, Text

  def status
    if self.app_status == 'new'
      if self.app_thread > 0
        'posted'
      else
        'pending'
      end
    else
      self.app_status
    end
  end
end

Applicant.destroy_all
OldApplicant.all(:app_mid.gt => 0, :app_thread.gt => 0, :char_race.not => '', :char_profile.not => '', :char_name.not => '', :order => [:app_id.desc]).each do |old|
  app = Applicant.new(
    # :status            => '',
    :user_id             => old.app_mid,
    # :topic_id          => old.app_thread,
    :name                => old.personal_name,
    :age                 => old.personal_age,
    :time_zone           => old.personal_timezone,
    # hours (see below)
    :known_members       => old.personal_members,
    :future_commitments  => old.personal_commitments,
    :reasons_for_joining => old.personal_reasons,
    :server_id           => 1,
    :character_name      => old.char_name,
    :character_class     => old.char_class,
    :character_race      => old.char_race,
    :armory_link         => old.char_profile,
    :previous_guilds     => old.wow_guilds,
    :reasons_for_leaving => old.wow_reasonleft,
    :pve_experience      => old.wow_pve,
    :pvp_experience      => old.wow_pvp,
    :connection_type     => old.sys_connection,
    :has_microphone      => old.sys_mic,
    :has_ventrilo        => old.sys_vent,
    :uses_ventrilo       => old.sys_talk,
    :comments            => old.comments
  )

  %w(sunday monday tuesday wednesday thursday friday saturday).each do |day|
    eval("app.start_#{day} = old.personal_hours#{day[0..1].downcase}1")
    eval("app.end_#{day} = old.personal_hours#{day[0..1].downcase}2")
  end

  app.status = old.status
  app.topic_id = old.app_thread
  app.created_at = old.app_subdate

  app.save!
end
