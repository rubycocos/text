# encoding: utf-8

module Pakman

class Finder

  include LogUtils::Logging


  def find_manifests( patterns, excludes=[] )
    manifests = []

    patterns.each do |pattern|
      pattern.gsub!( '\\', '/')  # normalize path; make sure all path use / only
      logger.debug "Checking >#{pattern}<"
      Dir.glob( pattern ) do |file|
        logger.debug "  Found manifest candidate >#{file}<"
        if File.directory?( file ) # NB: do not include directories
          logger.debug "  Skipping match; it's a directory"
        else
          unless exclude?( file, excludes )  # check for excludes; skip if excluded
            logger.debug "  Adding match >#{file}<"

            ## todo/fix:
            # array first entry - downcase and gsub('.txt','') ??
            # use Pakman.pakname_from_file()

            manifests << [ File.basename( file ), file ]
          end
        end
      end
    end

    manifests
  end

private
  def exclude?( file, excludes )
    excludes.each do |pattern|
      ## todo: FNM_DOTMATCH helps or not?? (make up some tests??)
      if File.fnmatch?( pattern, file, File::FNM_CASEFOLD | File::FNM_DOTMATCH )
        logger.debug "  Skipping match; it's excluded by pattern >#{pattern}<"
        return true
      end
    end
    false
  end

end # class Finder
end # module Pakman
