# encoding: utf-8

module Pakman

class Opts

  def list=(value)
    @list = value
  end

  def list?
    return false if @list.nil?  # default list flag is false
    @list == true
  end


  def generate=(value)
    @generate = value
  end

  def generate?
    return false if @generate.nil?   # default generate flag is false
    @generate == true
  end


  def fetch_uri=(value)
    @fetch_uri = value
  end

  def fetch_uri
    @fetch_uri || '-fetch uri required-'
  end

  def fetch?
    @fetch_uri.nil? ? false : true
  end


  def manifest=(value)
    @manifest = value
  end

  ## fix:/todo: use a different default manifest
  def manifest
    @manifest || 's6.txt'
  end


  def config_path=(value)
    @config_path = value
  end

  def config_path
    @config_path || '~/.pak'
  end


  def output_path=(value)
    @output_path = value
  end

  def output_path
    @output_path || '.'
  end

end # class Opts
end # module Pakman
