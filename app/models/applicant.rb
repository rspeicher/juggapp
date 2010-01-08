# == Schema Information
#
# Table name: applicants
#
#  id                  :integer(4)      not null, primary key
#  status              :string(255)     default("new")
#  user_id             :integer(4)
#  topic_id            :integer(4)
#  first_name          :string(255)
#  age                 :integer(4)
#  time_zone           :string(255)
#  start_sunday        :time
#  end_sunday          :time
#  start_monday        :time
#  end_monday          :time
#  start_tuesday       :time
#  end_tuesday         :time
#  start_wednesday     :time
#  end_wednesday       :time
#  start_thursday      :time
#  end_thursday        :time
#  start_friday        :time
#  end_friday          :time
#  start_saturday      :time
#  end_saturday        :time
#  known_members       :text
#  future_commitments  :text
#  reasons_for_joining :text
#  character_server    :string(255)
#  character_name      :string(255)
#  character_class     :string(255)
#  character_race      :string(255)
#  armory_link         :string(255)
#  original_owner      :boolean(1)
#  previous_guilds     :text
#  reasons_for_leaving :text
#  pve_experience      :text
#  pvp_experience      :text
#  screenshot_link     :string(255)
#  connection_type     :string(255)
#  has_microphone      :boolean(1)
#  has_ventrilo        :boolean(1)
#  uses_ventrilo       :boolean(1)
#  comments            :text
#  created_at          :datetime
#  updated_at          :datetime
#

class Applicant < ActiveRecord::Base
  WOW_CLASSES = ['Death Knight'] + (%w(Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)).sort.freeze
  WOW_RACES   = (['Blood Elf', 'Night Elf'] + (%w(Draenei Dwarf Gnome Human Orc Tauren Troll Undead))).sort.freeze
  WOW_SERVERS = [
    "Aegwynn",
    "Aerie Peak",
    "Agamaggan",
    "Aggramar",
    "Akama",
    "Alexstrasza",
    "Alleria",
    "Altar of Storms",
    "Alterac Mountains",
    "Aman'Thul",
    "Andorhal",
    "Anetheron",
    "Antonidas",
    "Anub'arak",
    "Anvilmar",
    "Arathor",
    "Archimonde",
    "Area 52",
    "Argent Dawn",
    "Arthas",
    "Arygos",
    "Auchindoun",
    "Azgalor",
    "Azjol-Nerub",
    "Azshara",
    "Azuremyst",
    "Baelgun",
    "Balnazzar",
    "Barthilas",
    "Black Dragonflight",
    "Blackhand",
    "Blackrock",
    "Blackwater Raiders",
    "Blackwing Lair",
    "Blade's Edge",
    "Bladefist",
    "Bleeding Hollow",
    "Blood Furnace",
    "Bloodhoof",
    "Bloodscalp",
    "Bonechewer",
    "Borean Tundra",
    "Boulderfist",
    "Bronzebeard",
    "Burning Blade",
    "Burning Legion",
    "Caelestrasz",
    "Cairne",
    "Cenarion Circle",
    "Cenarius",
    "Cho'gall",
    "Chromaggus",
    "Coilfang",
    "Crushridge",
    "Daggerspine",
    "Dalaran",
    "Dalvengyr",
    "Dark Iron",
    "Darkspear",
    "Darrowmere",
    "Dath'Remar",
    "Dawnbringer",
    "Deathwing",
    "Demon Soul",
    "Dentarg",
    "Destromath",
    "Dethecus",
    "Detheroc",
    "Doomhammer",
    "Draenor",
    "Dragonblight",
    "Dragonmaw",
    "Drak'Tharon",
    "Drak'thul",
    "Draka",
    "Drakkari",
    "Dreadmaul",
    "Drenden",
    "Dunemaul",
    "Durotan",
    "Duskwood",
    "Earthen Ring",
    "Echo Isles",
    "Eitrigg",
    "Eldre'Thalas",
    "Elune",
    "Emerald Dream",
    "Eonar",
    "Eredar",
    "Executus",
    "Exodar",
    "Farstriders",
    "Feathermoon",
    "Fenris",
    "Firetree",
    "Fizzcrank",
    "Frostmane",
    "Frostmourne",
    "Frostwolf",
    "Galakrond",
    "Garithos",
    "Garona",
    "Garrosh",
    "Ghostlands",
    "Gilneas",
    "Gnomeregan",
    "Gorefiend",
    "Gorgonnash",
    "Greymane",
    "Grizzly Hills",
    "Gul'dan",
    "Gundrak",
    "Gurubashi",
    "Hakkar",
    "Haomarush",
    "Hellscream",
    "Hydraxis",
    "Hyjal",
    "Icecrown",
    "Illidan",
    "Jaedenar",
    "Jubei'Thos",
    "Kael'thas",
    "Kalecgos",
    "Kargath",
    "Kel'Thuzad",
    "Khadgar",
    "Khaz Modan",
    "Khaz'goroth",
    "Kil'Jaeden",
    "Kilrogg",
    "Kirin Tor",
    "Korgath",
    "Korialstrasz",
    "Kul Tiras",
    "Laughing Skull",
    "Lethon",
    "Lightbringer",
    "Lightning's Blade",
    "Lightninghoof",
    "Llane",
    "Lothar",
    "Madoran",
    "Maelstrom",
    "Magtheridon",
    "Maiev",
    "Mal'Ganis",
    "Malfurion",
    "Malorne",
    "Malygos",
    "Mannoroth",
    "Medivh",
    "Misha",
    "Mok'Nathal",
    "Moon Guard",
    "Moonrunner",
    "Mug'thol",
    "Muradin",
    "Nagrand",
    "Nathrezim",
    "Nazgrel",
    "Nazjatar",
    "Ner'zhul",
    "Nesingwary",
    "Nordrassil",
    "Norgannon",
    "Onyxia",
    "Perenolde",
    "Proudmoore",
    "Quel'dorei",
    "Quel'Thalas",
    "Ragnaros",
    "Ravencrest",
    "Ravenholdt",
    "Rexxar",
    "Rivendare",
    "Runetotem",
    "Sargeras",
    "Saurfang",
    "Scarlet Crusade",
    "Scilla",
    "Sen'Jin",
    "Sentinels",
    "Shadow Council",
    "Shadowmoon",
    "Shadowsong",
    "Shandris",
    "Shattered Halls",
    "Shattered Hand",
    "Shu'halo",
    "Silver Hand",
    "Silvermoon",
    "Sisters of Elune",
    "Skullcrusher",
    "Skywall",
    "Smolderthorn",
    "Spinebreaker",
    "Spirestone",
    "Staghelm",
    "Steamwheedle Cartel",
    "Stonemaul",
    "Stormrage",
    "Stormreaver",
    "Stormscale",
    "Suramar",
    "Tanaris",
    "Terenas",
    "Terokkar",
    "Thaurissan",
    "The Forgotten Coast",
    "The Scryers",
    "The Underbog",
    "The Venture Co",
    "Thorium Brotherhood",
    "Thrall",
    "Thunderhorn",
    "Thunderlord",
    "Tichondrius",
    "Tortheldrin",
    "Trollbane",
    "Turalyon",
    "Twisting Nether",
    "Uldaman",
    "Uldum",
    "Undermine",
    "Ursin",
    "Uther",
    "Vashj",
    "Vek'nilash",
    "Velen",
    "Warsong",
    "Whisperwind",
    "WildHammer",
    "Windrunner",
    "Winterhoof",
    "Wyrmrest Accord",
    "Ysera",
    "Ysondre",
    "Zangarmarsh",
    "Zul'jin",
    "Zuluhed"
  ]

  validates_inclusion_of :status, :in => %w(new denied accepted guilded waiting)
  validates_presence_of :user_id
  validates_presence_of :character_name
  validates_inclusion_of :character_server, :in => WOW_SERVERS, :message => "{{value}} is not a valid US server"
  validates_inclusion_of :character_class, :in => WOW_CLASSES, :message => "{{value}} is not a valid class"
  validates_inclusion_of :character_race, :in => WOW_RACES, :message => "{{value}} is not a valid race"
  # validates_format_of :armory_link, :with => /^http:\/\/(www\.)?wowarmory\.com.+/, :message => 'is not a valid Armory link'
  
  belongs_to :user
end