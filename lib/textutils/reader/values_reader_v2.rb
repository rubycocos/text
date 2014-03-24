# encoding: utf-8

# fix: move into TextUtils namespace/module!!

## todo/fix: find a better name than HashReaderV2 (HashReaderPlus?) ??

class ValuesReaderV2
  include LogUtils::Logging

  def initialize( name, include_path, more_attribs={} )
    @name          = name
    @include_path  = include_path
    @more_attribs  = more_attribs
    
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
  attr_reader :more_attribs

  def each_line
    path          = "#{include_path}/#{name_real_path}.txt"
    reader        = ValuesReader.new( path, more_attribs )

    logger.info "parsing data '#{name}' (#{path})..."

    reader.each_line do |attribs, values|
      yield( attribs, values )
    end

    ConfDb::Model::Prop.create_from_fixture!( name, path )
  end

end # class ValuesReaderV2

