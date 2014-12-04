#!/bin/env ruby

require 'pp'
require 'yaml'
require 'hashr'
require 'icalendar'

plan = Hashr.new YAML::load File.open $FILENAME

pstart = Date.parse plan.start
pend   = Date.parse plan.end

cal = Icalendar::Calendar.new
date = pstart
while date < pend do
  wday =date.wday-1 % 8 
  day = plan.week.keys()[wday] if wday >= 0
  if day
    plan.week[day].each{|person,shift|
      cal.event do |e|
        e.dtstart     =  DateTime.parse "#{date.to_s} #{shift.start}"
        e.dtend       =  DateTime.parse "#{date.to_s} #{shift.end}"
        e.summary     = person.to_s
        e.description = "cafe"
        e.ip_class    = "PUBLIC"
      end
      }

    puts cal.to_ical
  end
  date = date.next
end

#pp plan.to_hash
#plan.week.each{|day,shift|
#  shift.each{|name,time|
#    puts "#{name} works #{day} from #{time.start} to #{time.end}"
#  }
#}

