# encoding: utf-8

##
## fix/todo: move to/merge into LineReader itself
#   e.g. use  fromString c'tor ??? or similar??

# fix: move into TextUtils namespace/module!!


class StringLineReader

  include LogUtils::Logging

  def initialize( data )
    @data = data
  end


  def each_line
    @data.each_line do |line|
  
      if line =~ /^\s*#/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug 'skipping comment line'
        next
      end
        
      if line =~ /^\s*$/ 
        # kommentar oder leerzeile überspringen 
        logger.debug 'skipping blank line'
        next
      end

      # remove leading and trailing whitespace
      line = line.strip
 
      yield( line )
    end # each lines
  end # method each_line

end


class LineReaderV2
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

  def each_line
    path          = "#{include_path}/#{name_real_path}.txt"
    reader        = LineReader.new( path )

    logger.info "parsing data '#{name}' (#{path})..."

    reader.each_line do |line|
      yield( line )
    end

    ## fix: move Prop table to props gem - why? why not??
    WorldDb::Models::Prop.create_from_fixture!( name, path )
  end

end # class LineReaderV2


class LineReader

  include LogUtils::Logging

  def initialize( path )
    @path = path

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    @data = File.read_utf8( @path )
  end

  def each_line
    @data.each_line do |line|

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
