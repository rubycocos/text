# encoding: utf-8


module TextUtils
  module ValueHelper


  def is_region?( value )
    # assume region code e.g. TX or N
    value =~ /^[A-Z]{1,2}$/
  end

  def is_year?( value )
    # founded/established year e.g. 1776
    value =~ /^[0-9]{4}$/
  end

  def is_website?( value )
    # check for url/internet address e.g. www.ottakringer.at
    #  - must start w/  www. or
    #  - must end w/   .com
    #
    # fix: support more url format (e.g. w/o www. - look for .com .country code etc.)
    value =~ /^www\.|\.com$/
  end

  def is_address?( value )
    # if value includes // assume address e.g. 3970 Weitra // Sparkasseplatz 160
    value =~ /\/{2}/
  end

  def is_taglist?( value )
    value =~ /^[a-z0-9\|_ ]+$/
  end


  end # module ValueHelper
end # module TextUtils
