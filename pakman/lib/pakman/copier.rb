# encoding: utf-8

module Pakman

class Copier

  include LogUtils::Logging


  def copy_pak( manifestsrc, pakpath )

    start = Time.now

    pakname = Pakman.pakname_from_file( manifestsrc )

    logger.info "Copying template pack '#{pakname}'"

    ## todo: after depreciate change back to just load_file
    manifest = Manifest.load_file_v2( manifestsrc )

    manifest.each do |entry|
      dest   = entry[0]
      source = entry[1]

      # get full (absolute) path and make sure path exists
      destfull = File.expand_path( dest, pakpath )
      destpath = File.dirname( destfull )
      FileUtils.makedirs( destpath ) unless File.directory?( destpath )

      logger.debug "destfull=>#{destfull}<"
      logger.debug "destpath=>#{destpath}<"

      logger.info "  Copying to #{dest} from #{source}..."
      FileUtils.copy( source, destfull )
    end

    logger.info "Done (in #{Time.now-start} s)."
  end # method copy_pak

end # class Copier
end # module Pakman
