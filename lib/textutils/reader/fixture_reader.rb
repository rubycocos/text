# encoding: utf-8

### read in a list of fixtures (that is, fixture names/files)

class FixtureReader

  include LogUtils::Logging

  def initialize( path )
    @path = path

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( @path )
    
    hash = YAML.load( text )
    
    ### build up array for fixtures from hash
    
    @ary = []
    
    hash.each do |key_wild, value_wild|
      key   = key_wild.to_s.strip
      
      logger.debug "yaml key:#{key_wild.class.name} >>#{key}<<, value:#{value_wild.class.name} >>#{value_wild}<<"
    
      if value_wild.kind_of?( String ) # assume single fixture name
        @ary << value_wild
      elsif value_wild.kind_of?( Array ) # assume array of fixture names as strings
        @ary = ary + value_wild
      else
        logger.error "unknow fixture type in setup (yaml key:#{key_wild.class.name} >>#{key}<<, value:#{value_wild.class.name} >>#{value_wild}<<); skipping"
      end
    end
    
    logger.debug "fixture setup:"
    logger.debug @ary.to_json
  end

  def each
    @ary.each do |fixture|
      yield( fixture )
    end
  end # method each

end # class FixtureReader
