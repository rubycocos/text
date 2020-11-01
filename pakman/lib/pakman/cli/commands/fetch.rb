# encoding: utf-8

module Pakman

class Fetch

  include LogUtils::Logging

  def initialize( opts )
    @opts = opts
  end

  attr_reader :opts

  def run
    logger.debug "fetch_uri: >#{opts.fetch_uri}<"
    src = opts.fetch_uri

    uri = URI.parse( src )
    logger.debug "scheme: >#{uri.scheme}<, host: >#{uri.host}<, port: >#{uri.port}<, path: >#{uri.path}<"

    pakname = Pakman.pakname_from_file( uri.path )
    logger.debug "pakname: >#{pakname}<"

    pakpath = File.expand_path( pakname, opts.config_path )
    logger.debug "pakpath: >#{pakpath}<"

    Fetcher.new.fetch_pak( src, pakpath )
  end # method run

end # class Fetch
end # module Pakman
