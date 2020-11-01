# encoding: utf-8

module Pakman

class List

  include LogUtils::Logging

  include ManifestHelper

  def initialize( opts )
    @opts = opts
  end

  attr_reader :opts

  def run
    manifests = installed_template_manifests

    puts 'Installed template packs in search path'

    installed_template_manifest_patterns.each_with_index do |pattern,i|
      puts "    [#{i+1}] #{pattern}"
    end
    puts '  include:'

    if manifests.empty?
      puts "    -- none --"
    else
      manifests.each do |manifest|
        puts "%16s (%s)" % [manifest[0].gsub('.txt',''), manifest[1]]
      end
    end
  end

end # class List
end # module Pakman
