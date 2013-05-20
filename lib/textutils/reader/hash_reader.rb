# encoding: utf-8


# fix: move into TextUtils namespace/module!!


## todo/fix: find a better name than HashReaderV2 (HashReaderPlus?) ??

class HashReaderV2
  include LogUtils::Logging

  def initialize( name, include_path )
    @name          = name
    @include_path  = include_path

    # map name to name_real_path
    #   name might include !/ for virtual path (gets cut off)
    #   e.g. at-austria!/w-wien/beers becomse w-wien/beers

    pos = @name.index( '!/')
    if pos.nil?
      @name_real_path = @name   # not found; real path is the same as name
    else
      # cut off everything until !/ e.g.
      #   at-austria!/w-wien/beers becomes
      #   w-wien/beers
      @name_real_path = @name[ (pos+2)..-1 ]
    end
  end

  attr_reader :name
  attr_reader :name_real_path
  attr_reader :include_path

  def each
    path          = "#{include_path}/#{name_real_path}.yml"
    reader        = HashReader.new( path )

    logger.info "parsing data '#{name}' (#{path})..."

    reader.each do |key, value|
      yield( key, value )
    end

    ## fix: move Prop table to props gem - why? why not??
    WorldDb::Models::Prop.create_from_fixture!( name, path )
  end

end # class HashReaderV2



class HashReader

  include LogUtils::Logging

  def initialize( path )
    @path = path

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    
    text = File.read_utf8( @path )
   
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

    text = text.gsub( /^([ ]*)(ON|On|on|NO|No|no|N|n|Y|y)[ ]*:/ ) do |value|
      logger.warn "hash reader - found implicit bool (#{$1}#{$2}) for key; adding quotes to turn into string; see yaml.org/refcard.html (path=#{path})"
      # nb: preserve leading spaces for structure - might be significant
      "#{$1}'#{$2}':"  # add quotes to turn it into a string (not bool e.g. true|false)
    end

    ## nb: value must be freestanding (only allow optional eol comment)
    ##  do not escape if part of string sequence e.g.
    ##  key: nb,nn,no,se   => nb,nn,'no',se  -- avoid!!

    text = text.gsub( /:[ ]+(ON|On|on|NO|No|no|N|n|Y|y)[ ]*($| #.*$)/ ) do |value|
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
