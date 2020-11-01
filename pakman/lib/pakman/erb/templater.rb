# encoding: utf-8

module Pakman

### todo:
##  rename to ErbTemplater  (or RubyTemplater) - why? why not?


class Templater

  include LogUtils::Logging


  def merge_pak( manifestsrc, pakpath, binding, name )

    start = Time.now

    pakname = Pakman.pakname_from_file( manifestsrc )

    logger.info "Merging template pack '#{pakname}'"

    # todo: rename to load_file once depreated API got removed
    manifest = Manifest.load_file_v2( manifestsrc )

    manifest.each do |entry|
      dest   = entry[0]
      source = entry[1]

      if dest =~ /__file__/   # replace w/ name
        dest = dest.gsub( '__file__', name )
      end

      # get full (absolute) path and make sure path exists
      destfull = File.expand_path( dest, pakpath )
      destpath = File.dirname( destfull )
      FileUtils.makedirs( destpath ) unless File.directory?( destpath )

      logger.debug "destfull=>#{destfull}<"
      logger.debug "destpath=>#{destpath}<"

      if source =~ /\.erb\.|.erb$/
        logger.info "  Merging to #{dest}..."

        out = File.new( destfull, 'w+:utf-8' )   ## note: use utf8 (by default)
        out << ErbTemplate.from_file( source ).render( binding )
        out.flush
        out.close
      else
        logger.info "  Copying to #{dest} from #{source}..."

        FileUtils.copy( source, destfull )
      end
    end # each entry in manifest

    logger.info "Done (in #{Time.now-start} s)."
  end # method merge_pak

end # class Templater
end # module Pakman
