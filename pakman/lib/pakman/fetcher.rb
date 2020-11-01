# encoding: utf-8

module Pakman

class Fetcher

  include LogUtils::Logging


  def fetch_pak( manifestsrc, pakpath )

    start = Time.now

    uri = URI.parse( manifestsrc )

    logger.debug "scheme: #{uri.scheme}, host: #{uri.host}, port: #{uri.port}, path: #{uri.path}"

    dirname  = File.dirname( uri.path )
    filename = File.basename( uri.path )       # e.g. fullerscreen.txt (with extension)

    pakname = Pakman.pakname_from_file( uri.path )

    logger.debug "dirname >#{dirname}<"
    logger.debug "filename >#{filename}<"
    logger.debug "pakname >#{pakname}<"

    dlbase = "#{uri.scheme}://#{uri.host}:#{uri.port}#{dirname}"
    logger.debug "dlbase: #{dlbase}"
    logger.debug "pakpath: #{pakpath}"

    FileUtils.makedirs( pakpath ) unless File.directory?( pakpath )

    logger.info "Fetching template pack '#{pakname}'"
    logger.info "    from '#{dlbase}'"
    logger.info "    saving to '#{pakpath}'"

    # step 1: download manifest
    manifestdest = "#{pakpath}/#{filename}"

    logger.info "  Downloading manifest '#{filename}'..."

    fetch_file( manifestsrc, manifestdest )

    ## todo: change back to load_file_core after deprecated api got removed
    manifest = Manifest.load_file_core_v2( manifestdest )

    # step 2: download files & templates listed in manifest
    manifest.each do |entry|
      source = entry[1]

      # get full (absolute) path and make sure path exists
      destfull = File.expand_path( source, pakpath )  # NB: turning source into dest
      destpath = File.dirname( destfull )
      FileUtils.makedirs( destpath ) unless File.directory?( destpath )

      logger.debug "destfull=>#{destfull}<"
      logger.debug "destpath=>#{destpath}<"

      sourcefull = "#{dlbase}/#{source}"

      if source =~ /\.erb\.|.erb$/
        logger.info "  Downloading template '#{source}'..."
      else
        logger.info "  Downloading file '#{source}'..."
      end

      fetch_file( sourcefull, destfull )
    end
    logger.info "Done (in #{Time.now-start} s)."
  end # method fetch_pak

private

  def fetch_file( src, dest )
     ## note: code moved to its own gem, that is, fetcher
     ## see https://github.com/geraldb/fetcher

    ::Fetcher::Worker.new.copy( src, dest )
  end

end # class Fetcher
end # module Pakman
