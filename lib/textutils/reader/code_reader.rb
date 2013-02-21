# encoding: utf-8

class CodeReader

  def logger
    @logger ||= LogUtils[ self ]
  end

  def initialize( path )
    @path   = path

    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see worlddb/utils.rb
    
    @code  = File.read_utf8( @path )
  end

  def eval( klass )
    klass.class_eval( @code )

    # NB: same as
    #
    # module WorldDB
    #   include WorldDB::Models
    #  <code here>
    # end
  end

end # class CodeReader