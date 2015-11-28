# encoding: utf-8

# fix: move into TextUtils namespace/module!!

class CodeReader

  include LogUtils::Logging

  def self.from_file( path )
    ## nb: assume/enfore utf-8 encoding (with or without BOM - byte order mark)
    ## - see textutils/utils.rb
    code = File.read_utf8( path )
    self.from_string( code )
  end

  def self.from_string( code )
    CodeReader.new( code: code )
  end


  def initialize( arg )
    if arg.is_a?( String )  ## old style (deprecated) - pass in filepath as string
      path = arg
      logger.info "CodeReader.new - deprecated API - use CodeReader.from_file() instead"
      @code = File.read_utf8( path )
    else   ## assume it's a hash
      opts = arg
      @code = opts[:code]
    end
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
