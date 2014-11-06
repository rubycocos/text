# encoding: utf-8

### read in a list of fixtures (that is, fixture names/files)

# fix: move into TextUtils namespace/module!!

##
#  use ManifestReader ?? why? why not?  - reuse in manifest gem (or manman e.g. manifest manger) ??
#

class FixtureReader

  include LogUtils::Logging


  def self.from_zip( zip_file, entry_path )
    entry = zip_file.find_entry( entry_path )

    ## todo/fix: add force encoding to utf-8 ??
    ##  check!!!
    ##  clean/prepprocess lines
    ##  e.g. CR/LF (/r/n) to LF (e.g. /n)
    text = entry.get_input_stream().read()

    ## NOTE: needs logger ref; only available in instance methods; use global logger for now
    logger = LogUtils::Logger.root
    logger.debug "text.encoding.name (before): #{text.encoding.name}"
#####
# NB: ASCII-8BIT == BINARY == Encoding Unknown; Raw Bytes Here
## NB:
# for now "hardcoded" to utf8 - what else can we do?
# - note: force_encoding will NOT change the chars only change the assumed encoding w/o translation
    text = text.force_encoding( Encoding::UTF_8 )
    logger.debug "text.encoding.name (after): #{text.encoding.name}"     

    ## todo:
    # NB: for convenience: convert fancy unicode dashes/hyphens to plain ascii hyphen-minus
    ## text = TextUtils.convert_unicode_dashes_to_plain_ascii( text, path: path )

    self.from_string( text )
  end

  def self.from_file( path )
    ## note: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text )
  end

  def self.from_string( text )
    FixtureReader.new( { text: text } )
  end


  def initialize( arg )

    if arg.is_a?( String )  ## old style (deprecated) - pass in filepath as string
      path = arg
      logger.info "FixtureReader.new - deprecated API - use FixtureReader.from_file() instead"
      text = File.read_utf8( path )
    else   ## assume it's a hash
      opts = arg
      text = opts[:text]
    end

    @ary = []

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
  
    @ary = plain_text_reader( text )

    logger.debug "fixture setup:"
    logger.debug @ary.to_json
  end


  def plain_text_reader( text )     ## find a better name - just read?

    ## use LineReader ?? for (re)use of comment processing - why? why not???
    ### build up array for fixtures from hash
    ary = []

    text.each_line do |line|

      # comments allow:
      # 1) #####  (shell/ruby style)
      # 2) --  comment here (haskel/?? style)
      # 3) % comment here (tex/latex style)

      if line =~ /^\s*#/ || line =~ /^\s*--/ || line =~ /^\s*%/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug 'skipping comment line'
        next
      end

      if line =~ /^\s*$/ 
        # skip blank lines
        logger.debug 'skipping blank line'
        next
      end

      # pass 1) remove possible trailing eol comment
      ##  e.g    -> nyc, New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> nyc, New York

      line = line.sub( /\s+#.+$/, '' )

      # pass 2) remove leading and trailing whitespace
      
      line = line.strip
 
      ary << line
    end # each lines
    ary  # return fixture ary
  end # method plain_text_reader


  def each
    @ary.each do |fixture|
      yield( fixture )
    end
  end # method each

end # class FixtureReader
