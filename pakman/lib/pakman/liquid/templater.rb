# encoding: utf-8

module Pakman


class LiquidTemplater

  include LogUtils::Logging


  ###
  ## check these file extensions for processing
  ##   processing (w/ liquid) if front matter header found / present

  EXTS = ['html', 'svg',
          'js',   'json',
          'css',
          'txt',  'text',
          'md',   'markdown']

  ## convert html to \.html$ (e.g. match end-of-string and leading dot)
  ##  e.g.  /\.(html|svg|...)$|/ etc.
  REGEX_EXT = Regexp.new( "\\.(#{EXTS.join('|')})$", Regexp::IGNORECASE )


  ## rename binding/hash to assigns or something more specific - why? why not?
  def merge_pak( manifestsrc, pakpath, binding, name )

    start = Time.now

    pakname = Pakman.pakname_from_file( manifestsrc )

    puts "Merging template pack '#{pakname}'"

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

      ###
      # note:
      #  use jekyll convention for now
      #   check if file starts with front matter (yaml block)
      #   if yes, process (with liquid) otherwise copy as is 1:1

      ####
      # note: for now only check files with known source extensions!!!
      #   do NOT check binaries (e.g. gif, png, ico, etc. -- regex will fail w/ encoding error)
      #    todo/check:  check how jekyll works e.g. does jekyll check binaries for front-matter etc. ????

      is_source_page = REGEX_EXT.match( source )   # note: returns nil or MatchData - do NOT use check == false or true (will NOT work)

      if is_source_page.nil?
        puts "    No (pre-)processing for '#{source}' (copy 1:1) - no matching (known) source extension e.g. #{EXTS.join('|')}"
        source_page = nil
      else
        source_page = Page.from_file( source )
      end

      if source_page && source_page.headers?
        puts "  Bingo! Front matter (e.g. ---) found. Merging template to #{dest}..."

        out = File.new( destfull, 'w+:utf-8' )     ## note: use utf8
        ## note: only pass along contents (not headers e.g. front matter for now)
        ##  (auto-)add front matter headers as page.[xxx] - why? why not??
        out << LiquidTemplate.from_string( source_page.contents ).render( binding )
        out.flush
        out.close
      else
        puts "  Copying to #{dest} from #{source}..."

        FileUtils.copy( source, destfull )
      end
    end # each entry in manifest

    puts "Done (in #{Time.now-start} s)."
  end # method merge_pak

end # class LiquidTemplater
end # module Pakman
