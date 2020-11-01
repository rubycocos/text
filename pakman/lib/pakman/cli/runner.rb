# encoding: utf-8

module Pakman

class Runner

  include LogUtils::Logging

  def initialize
    @opts = Opts.new
  end

  attr_reader :opts

  def run( args )
    opt=OptionParser.new do |cmd|

      cmd.banner = "Usage: pakman [options]"

      cmd.on( '-f', '--fetch URI', 'Fetch Templates' ) do |uri|
        opts.fetch_uri = uri
      end

      cmd.on( '-t', '--template MANIFEST',  'Generate Templates' ) do |manifest|
        opts.generate = true
        opts.manifest = manifest
      end

      cmd.on( '-l', '--list', "List Installed Templates" ) { opts.list = true }

      cmd.on( '-c', '--config PATH', "Configuration Path (default is #{opts.config_path})" ) do |path|
        opts.config_path = path
      end

      cmd.on( '-o', '--output PATH', "Output Path (default is #{opts.output_path})" ) { |path| opts.output_path = path }

      cmd.on( '-v', '--version', "Show version" ) do
        puts Pakman.banner
        exit
      end

      cmd.on( "--verbose", "Show debug trace" )  do
        ## logger.datetime_format = "%H:%H:%S"
        ## logger.level = Logger::DEBUG
        # fix: use logutils - set to debug
      end

      cmd.on_tail( "-h", "--help", "Show this message" ) do
        puts <<EOS

pakman - Lets you manage template packs.

#{cmd.help}

Examples:
    pakman -f URI                             # to be done
    pakman -f URI  -c ~/.slideshow/templates

    pakman -l                                 # to be done
    pakman -l -c ~/.slideshow/templates

    pakman -t s6
    pakman -t s6 ruby19.yml
    pakman -t s6 ruby19.yml tagging.yml
    pakman -t s6 -o o
    pakman -t s6 -c ~/.slideshow/templates

Further information:
  http://geraldb.github.com/pakman

EOS
        exit
      end
    end

    opt.parse!( args )

    puts Pakman.banner

    if opts.list?
      List.new( opts ).run
    elsif opts.generate?
      Gen.new( opts ).run( args )
    elsif opts.fetch?
      Fetch.new( opts ).run
    else
      puts "-- No command do nothing for now.  --"  ## run help??
      puts "Done."
    end
  end   # method run

end # class Runner
end # module Pakman
