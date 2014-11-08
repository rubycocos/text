# encoding: utf-8

# fix: move into TextUtils namespace/module!!


class StringLineReader
  ## fix/todo:
  ##   remove - deprecated/obsolete - do NOT use
  ##   use LineReader.from_string

  include LogUtils::Logging

  def initialize( text )
    logger.info "StringLineReader.new - deprecated API - use LineReader.from_string() instead"
    @reader = LineReader.from_string( text )
  end

  def each_line
    @reader.each_line do |line|    
      yield( line )
    end # each lines
  end # method each_line
end



class LineReader

  include LogUtils::Logging

  def self.from_file( path )
    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    text = File.read_utf8( path )
    self.from_string( text )
  end

  def self.from_string( text )
    LineReader.new( text: text )
  end


  def initialize( arg )
    if arg.is_a?( String )  ## old style (deprecated) - pass in filepath as string
      path = arg
      logger.info "LineReader.new - deprecated API - use LineReader.from_file() instead"
      @text = File.read_utf8( path )
    else   ## assume it's a hash
      opts = arg
      @text = opts[:text]
    end
  end

  def each_line
    @text.each_line do |line|

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
        # kommentar oder leerzeile überspringen 
        logger.debug 'skipping blank line'
        next
      end

      # pass 1) remove possible trailing eol comment
      ##  e.g    -> nyc, New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> nyc, New York

      line = line.sub( /\s+#.+$/, '' )

      # pass 2) remove leading and trailing whitespace
      
      line = line.strip
 
      yield( line )
    end # each lines
  end # method each_line
  
end # class LineReader
