# encoding: utf-8


module TextUtils
  module ValueHelper

  #####
  ## fix!!!!: move to beerdb ??? why? why not?? - yes, move to beerdb-models

  def match_brewery( value )
    if value =~ /^by:/   ## by:  -brewed by/brewery
      brewery_key = value[3..-1]  ## cut off by: prefix
      brewery = BeerDb::Model::Brewery.find_by_key!( brewery_key )
      yield( brewery )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def is_year?( value )
    # founded/established year e.g. 1776
    match_result =  value =~ /^[0-9]{4}$/
    # match found if 0,1,2,3 etc or no match if nil
    # note: return bool e.g. false|true  (not 0,1,2,3 etc. and nil)
    match_result != nil
  end


  def match_year( value )
    if is_year?( value )  # founded/established year e.g. 1776
      yield( value.to_i )
      true # bingo - match found
    else
      false # no match found
    end
  end


  def is_address?( value )
    # if value includes // assume address e.g. 3970 Weitra // Sparkasseplatz 160
    match_result =  value =~ /\/{2}/
    # match found if 0,1,2,3 etc or no match if nil
    # note: return bool e.g. false|true  (not 0,1,2,3 etc. and nil)
    match_result != nil
  end

  def is_taglist?( value )
    ### note: cannot start w/ number must be letter for now
    ##  -- in the future allow free standing years (e.g. 1980 etc.?? why? why not?)
    ##  e.g. not allowed  14 ha or 5_000 hl etc.
    match_result =  value =~ /^([a-z][a-z0-9\|_ ]*[a-z0-9]|[a-z])$/
    # match found if 0,1,2,3 etc or no match if nil
    # note: return bool e.g. false|true  (not 0,1,2,3 etc. and nil)
    match_result != nil
  end


  def is_website?( value )
    # check for url/internet address e.g. www.ottakringer.at
    #  - must start w/  www. or
    #  - must end w/   .com
    #
    # fix: support more url format (e.g. w/o www. - look for .com .country code etc.)
    match_result =  value =~ /^www\.|\.com$/
    # match found if 0,1,2,3 etc or no match if nil
    # note: return bool e.g. false|true  (not 0,1,2,3 etc. and nil)
    match_result != nil
  end

  def match_website( value )
    if is_website?( value )   # check for url/internet address e.g. www.ottakringer.at
      # fix: support more url format (e.g. w/o www. - look for .com .country code etc.)
      yield( value )
      true # bingo - match found
    else
      false # no match found
    end
  end

  end # module ValueHelper
end # module TextUtils
