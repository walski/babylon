# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'httparty'
require './lib/babylon.rb'

Hoe.new('babylon', Babylon::VERSION) do |p|
  p.rubyforge_name = "kickassrb"
  p.name = "babylon"
  p.author = "Thorben Schröder"
  p.description = "Free language determination from content using Google API."
  p.email = 'thorben@fetmab.net'
  p.summary = "Free language determination from content using Google API."
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.extra_deps << ['httparty'," >=0.1.3"]
end

# vim: syntax=Ruby
