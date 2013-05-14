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


  def find_grade( text )  # NB: returns ary [grade,text] / two values
    grade = 4  # defaults to grade 4  e.g  *** => 1, ** => 2, * => 3, -/- => 4

    text = text.sub( /\s+(\*{1,3})\s*$/ ) do |_|  # NB: stars must end field/value
      if $1 == '***'
        grade = 1
      elsif $1 == '**'
        grade = 2
      elsif $1 == '*'
        grade = 3
      else
        # unknown grade; not possible, is'it?
      end
      ''  # remove * from title if found
    end

    [grade,text]
  end



  end # module ValueHelper
end # module TextUtils
