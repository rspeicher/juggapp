module ApplicantsHelper
  def class_icon(klass)
    klass.gsub!(' ', '')

    "classes/#{klass}.png"
  end

  def character_icon(race, klass)
    race.downcase!
    klass.downcase!

    # Base
    str = "http://www.wowarmory.com/_images/portraits/wow-80/"

    # Sex
    str += '0-' # TODO: Females are '1-'

    # Race ID
    str += case race
    when 'human'
      '1'
    when 'orc'
      '2'
    when 'dwarf'
      '3'
    when 'night elf'
      '4'
    when 'undead'
      '5'
    when 'tauren'
      '6'
    when 'gnome'
      '7'
    when 'troll'
      '8'
    when 'blood elf'
      '10'
    when 'dranei'
      '11'
    else
      '0'
    end
    str += '-'

    # Class ID
    str += case klass
    when 'warrior'
      '1'
    when 'paladin'
      '2'
    when 'hunter'
      '3'
    when 'rogue'
      '4'
    when 'priest'
      '5'
    when 'death knight'
      '6'
    when 'shaman'
      '7'
    when 'mage'
      '8'
    when 'warlock'
      '9'
    when 'druid'
      '11'
    else
      '0'
    end

    str += '.gif'

    str
  end

  def play_time_for_day(app, day)
    day.downcase!

    format = "%I:%M %p"
    pstart = app.attributes["start_#{day}"].strftime(format)
    pend   = app.attributes["end_#{day}"].strftime(format)

    "#{pstart} until #{pend} CST #{day.titlecase}"
  rescue
    "N/A until N/A CST #{day.titlecase}"
  end
end
