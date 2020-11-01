# encoding: utf-8

module Pakman

class Manifest

  include LogUtils::Logging


  def initialize()
    @manifest = []
  end

  def self.load_file_core( old_logger_do_not_use, path )
    puts "*** deprecated API call [Pakman::Manifest.load_file_core] - do NOT pass in logger; no longer required/needed; logger arg will get removed"

    obj = self.new
    obj.load_file_core_worker( path )
    obj
  end

  def self.load_file( old_logger_do_not_use, path )
    puts "*** deprecated API call [Pakman::Manifest.load_file] - do NOT pass in logger; no longer required/needed; logger arg will get removed"

    obj = self.new
    obj.load_file_worker( path )
    obj
  end


  def self.load_file_core_v2( path )
    obj = self.new
    obj.load_file_core_worker( path )
    obj
  end

  def self.load_file_v2( path )
    obj = self.new
    obj.load_file_worker( path )
    obj
  end




  def each
    @manifest.each { |ary| yield ary }
  end



  def load_file_core_worker( path )
    @manifest = []

    File.open( path, 'r:bom|utf-8' ).readlines.each_with_index do |line,i|
      case line
      when /^\s*$/
        # skip empty lines
      when /^\s*#.*$/
        # skip comment lines
      else
        logger.debug "line #{i+1}: #{line.strip}"
        values = line.strip.split( /[ <,+]+/ )

        # add source for shortcuts (assumes relative path; if not issue warning/error)
        values << values[0] if values.size == 1

        @manifest << values
      end
    end
  end

  def load_file_worker( path )
    filename = path

    logger.info "  Loading template manifest #{filename}..."
    load_file_core_worker( filename )

    # post-processing
    # normalize all source paths (1..-1) /make full path/add template dir

    templatesdir = File.dirname( path )
    logger.debug "templatesdir=#{templatesdir}"

    @manifest.each do |values|
      (1..values.size-1).each do |i|
        values[i] = "#{templatesdir}/#{values[i]}"
        logger.debug "  path[#{i}]=>#{values[i]}<"
      end
    end
  end


end  # class Manifest
end  # module Pakman
