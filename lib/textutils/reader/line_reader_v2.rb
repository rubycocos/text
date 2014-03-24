# encoding: utf-8


# fix: move into TextUtils namespace/module!!


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

    ConfDb::Model::Prop.create_from_fixture!( name, path )
  end

end # class LineReaderV2

