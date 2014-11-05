
  if @path.ends_with?( '.yml' ) || @path.ends_with?( '.yaml' )
      ### fix/todo: remove later on!!! - do not use!!
      puts "deprecated api - FixtureReader w/ yaml format - will get removed; please use new plain text manifest format"
      @ary = old_deprecated_yaml_reader( text )
  else
    ..
  end


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
