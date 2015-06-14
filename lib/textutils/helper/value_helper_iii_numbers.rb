# encoding: utf-8


# match numbers (units)
#  e.g  km_squared, abv, etc.

module TextUtils
  module ValueHelper


  def match_number( value )
    ## numeric
    ##   note: can use any _ or spaces inside digits e.g. 1_000_000 or 1 000 000)
    if value =~ /^([0-9][0-9 _]+[0-9])|([0-9]{1,2})$/
      num = value.gsub(/[ _]/, '').to_i
      yield( num )
      true # bingo - match found
    else
      false # no match found
    end
  end


  ###########################
  ## numbers w/ units

  def match_km_squared( value )
    ## allow numbers like 453 km² or 45_000 km2
    if value =~ /^([0-9][0-9 _]+[0-9]|[0-9]{1,2})(?:\s*(?:km2|km²)\s*)$/
      num = value.gsub( 'km2', '').gsub( 'km²', '' ).gsub(/[ _]/, '').to_i
      yield( num )
      true # bingo - match found
    else
      false # no match found
    end
  end

  def match_abv( value )  # alcohol by volume (abv) e.g. 5.2% 
    if value =~ /^<?\s*(\d+(?:\.\d+)?)\s*%$/
      # nb: allow leading < e.g. <0.5%
      yield( $1.to_f )  # convert to decimal? how? use float?
      true # bingo - match found
    else
      false # no match found
    end
  end

  def match_og( value ) # plato (stammwuerze/gravity?) e.g. 11.2°
    if value =~ /^(\d+(?:\.\d+)?)°$/
      # nb: no whitespace allowed between ° and number e.g. 11.2°
      yield( $1.to_f )  # convert to decimal? how? use float?
      true # bingo - match found
    else
      false # no match found
    end
  end

  def match_kcal( value )
    if value =~ /^(\d+(?:\.\d+)?)\s*kcal(?:\/100ml)?$/  # kcal
      # nb: allow 44.4 kcal/100ml or 44.4 kcal or 44.4kcal
      yield( $1.to_f )  # convert to decimal? how? use float?
      true # bingo - match found
    else
      false # no match found
    end
  end

  def match_hl( value )  # hector liters (hl) 1hl = 100l
    if value =~ /^(?:([0-9][0-9_ ]+[0-9]|[0-9]{1,2})\s*hl)$/  # e.g. 20_000 hl or 50hl etc.
      yield( $1.gsub( /[ _]/, '' ).to_i )
      true # bingo - match found
    else
      false # no match found
    end
  end

  end # module ValueHelper
end # module TextUtils
