# encoding: utf-8

# fix: move into TextUtils namespace/module!!


class HashReader

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
    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text )
  end

  def self.from_string( text )
    HashReader.new( text: text )
  end

  def initialize( arg )

    if arg.is_a?( String )  ## old style (deprecated) - pass in filepath as string
      path = arg
      logger.info "HashReader.new - deprecated API - use HashReader.from_file() instead"
      text = File.read_utf8( path )
    else   ## assume it's a hash
      opts = arg
      text = opts[:text]
    end

    ### hack for syck yaml parser (e.g.ruby 1.9.2) (cannot handle !!null)
    ##   change it to !null to get plain nil
    ##   w/ both syck and psych/libyml

    text = text.gsub( '!!null', '!null' )
   
    ### hacks for yaml
    
    ### see yaml gotschas
    ##  - http://www.perlmonks.org/?node_id=738671
    ##  - 

    ## replace all tabs w/ two spaces and issue a warning
    ## nb: yaml does NOT support tabs see why here -> yaml.org/faq.html
    
    text = text.gsub( "\t" ) do |_|
      logger.warn "hash reader - found tab (\t) replacing w/ two spaces; yaml forbids tabs; see yaml.org/faq.html (path=#{path})"
      '  '  # replace w/ two spaces
    end

    ## quote implicit boolean types on,no,n,y

    ## nb: escape only if key e.g. no: or "free standing" value on its own line e.g.
    ##   no: no

    text = text.gsub( /^([ ]*)(ON|On|on|OFF|Off|off|YES|Yes|yes|NO|No|no|Y|y|N|n)[ ]*:/ ) do |value|
      logger.warn "hash reader - found implicit bool (#{$1}#{$2}) for key; adding quotes to turn into string; see yaml.org/refcard.html (path=#{path})"
      # nb: preserve leading spaces for structure - might be significant
      "#{$1}'#{$2}':"  # add quotes to turn it into a string (not bool e.g. true|false)
    end

    ## nb: value must be freestanding (only allow optional eol comment)
    ##  do not escape if part of string sequence e.g.
    ##  key: nb,nn,no,se   => nb,nn,'no',se  -- avoid!!
    #
    #  check: need we add true|false too???

    text = text.gsub( /:[ ]+(ON|On|on|OFF|Off|off|YES|Yes|yes|NO|No|no|Y|y|N|n)[ ]*($| #.*$)/ ) do |value|
      logger.warn "hash reader - found implicit bool (#{$1}) for value; adding quotes to turn into string; see yaml.org/refcard.html (path=#{path})"
      ": '#{$1}'"  # add quotes to turn it into a string (not bool e.g. true|false)
    end

    
    @hash = YAML.load( text )
  end
  
  ###
  # nb: returns all values as strings
  #
  
  def each
    @hash.each do |key_wild, value_wild|
      # normalize
      # - key n value as string (not symbols, bool? int? array?)
      # - remove leading and trailing whitespace
      key   = key_wild.to_s.strip
      value = value_wild.to_s.strip
      
      logger.debug "yaml key:#{key_wild.class.name} >>#{key}<<, value:#{value_wild.class.name} >>#{value}<<"
    
      yield( key, value )
    end
  end # method each
  
  ###
  # todo: what name to use: each_object or each_typed ???
  #   or use new TypedHashReader class or similar??
  
  def each_typed
    @hash.each do |key_wild, value_wild|
      # normalize
      # - key n value as string (not symbols, bool? int? array?)
      # - remove leading and trailing whitespace
      key   = key_wild.to_s.strip
      
      if value_wild.is_a?( String )
        value = value_wild.strip
      else
        value = value_wild
      end
      
      logger.debug "yaml key:#{key_wild.class.name} >>#{key}<<, value:#{value_wild.class.name} >>#{value}<<"
    
      yield( key, value )
    end
  end # method each

end # class HashReader
