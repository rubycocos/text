# encoding: utf-8

### read in a list of fixtures (that is, fixture names/files)

# fix: move into TextUtils namespace/module!!

##
#  use ManifestReader ?? why? why not?  - reuse in manifest gem (or manman e.g. manifest manger) ??
#    

class FixtureReader

  include LogUtils::Logging

  def initialize( path )
    @path = path
  
    @ary = []

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( @path )
  
    if @path.ends_with?( '.yml' ) || @path.ends_with?( '.yaml' )
      ### fix/todo: remove later on!!! - do not use!!
      puts "deprecated api - FixtureReader w/ yaml format - will get removed; please use new plain text manifest format"
      @ary = old_deprecated_yaml_reader( text )
    else
      @ary = plain_text_reader( text )
    end

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


  def old_deprecated_yaml_reader( text )
    hash = YAML.load( text )
    
    ### build up array for fixtures from hash
    ary = []
    
    hash.each do |key_wild, value_wild|
      key   = key_wild.to_s.strip
      
      logger.debug "yaml key:#{key_wild.class.name} >>#{key}<<, value:#{value_wild.class.name} >>#{value_wild}<<"
    
      if value_wild.kind_of?( String ) # assume single fixture name
        ary << value_wild
      elsif value_wild.kind_of?( Array ) # assume array of fixture names as strings
        ary = ary + value_wild
      else
        logger.error "unknow fixture type in setup (yaml key:#{key_wild.class.name} >>#{key}<<, value:#{value_wild.class.name} >>#{value_wild}<<); skipping"
      end
    end
    ary  # return fixture ary
  end



  def each
    @ary.each do |fixture|
      yield( fixture )
    end
  end # method each

end # class FixtureReader
