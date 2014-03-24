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

    ConfDb::Model::Prop.create_from_fixture!( name, path )
  end


  def each_typed
    path          = "#{include_path}/#{name_real_path}.yml"
    reader        = HashReader.new( path )

    logger.info "parsing data '#{name}' (#{path})..."

    reader.each_typed do |key, value|
      yield( key, value )
    end

    ConfDb::Model::Prop.create_from_fixture!( name, path )
  end


end # class HashReaderV2
