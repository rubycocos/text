# encoding: utf-8


module TextUtils
  module ValueHelper


  ## todo/check: add to pair of matchers??
  # e.g. match_country and match_country!
  #  - match_country will use find_by_key and match_country will use find_by_key! - why? why not?

  def match_country( value )
    if value =~ /^country:/       # country:
      country_key = value[8..-1]  # cut off country: prefix
      country = WorldDb::Model::Country.find_by_key!( country_key )
      yield( country )
      true # bingo - match found
    else
      false # no match found
    end
  end

  def match_supra( value )
    if value =~ /^supra:/         # supra:
      country_key = value[6..-1]  # cut off supra: prefix
      country = WorldDb::Model::Country.find_by_key!( country_key )
      yield( country )
      true # bingo - match found
    else
      false # no match found
    end
  end

  def match_supra_flag( value )  # supranational (country)
    if value =~ /^supra$/   # supra(national)
      yield( true )
      true # bingo - match found
    else
      false # no match found
    end
  end




  def is_region?( value )
    # assume region code e.g. TX or N
    #
    # fix: allow three letter regions too e.g. BRU (brussels)
    match_result =  value =~ /^[A-Z]{1,2}$/
    # match found if 0,1,2,3 etc or no match if nil
    # note: return bool e.g. false|true  (not 0,1,2,3 etc. and nil)
    match_result != nil
  end

  ## fix/todo: use match_region_for_country! w/ !!! why? why not?
  def match_region_for_country( value, country_id )  ## NB: required country_id 
    if value =~ /^region:/   ## region:
      region_key = value[7..-1]  ## cut off region: prefix
      region = WorldDb::Model::Region.find_by_key_and_country_id!( region_key, country_id )
      yield( region )
      true  # bingo - match found
    elsif is_region?( value )  ## assume region code e.g. TX or N
      region = WorldDb::Model::Region.find_by_key_and_country_id!( value.downcase, country_id )
      yield( region )
      true  # bingo - match found
    else
      false # no match found
    end
  end


  def match_city( value )  # NB: might be nil (city not found)
    if value =~ /^city:/   ## city:
      city_key = value[5..-1]  ## cut off city: prefix
      city = WorldDb::Model::City.find_by_key( city_key )
      yield( city )  # NB: might be nil (city not found)
      true # bingo - match found
    else
      false # no match found
    end
  end


  def match_metro( value )
    if value =~ /^metro:/   ## metro:
      city_key = value[6..-1]  ## cut off metro: prefix
      city = WorldDb::Model::City.find_by_key!( city_key )   # NB: parent city/metro required, that is, lookup w/ !
      yield( city )
      true # bingo - match found
    else
      false # no match found
    end
  end

  ######
  ## fix: move to worlddb?? why why not??
  def match_metro_flag( value )
    if value =~ /^metro$/   # metro(politan area)
      yield( true )
      true # bingo - match found
    else
      false # no match found
    end
  end

  ######
  ## fix: move to worlddb?? why why not??
  def match_metro_pop( value )
    if value =~ /^m:/   # m:
      num = value[2..-1].gsub(/[ _]/, '').to_i   # cut off m: prefix; allow space and _ in number
      yield( num )
      true # bingo - match found
    else
      false # no match found
    end
  end



  #####
  ## fix: move to beerdb ??? why? why not??
  
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

  def match_number( value )
    ## numeric (nb: can use any _ or spaces inside digits e.g. 1_000_000 or 1 000 000)
    if value =~ /^([0-9][0-9 _]+[0-9])|([0-9]{1,2})$/
      num = value.gsub(/[ _]/, '').to_i
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


  def find_grade( value )  # NB: returns ary [grade,value] / two values
    grade = 4  # defaults to grade 4  e.g  *** => 1, ** => 2, * => 3, -/- => 4

    # NB: stars must end field/value or start field/value
    #  e.g.
    #  *** Anton Bauer   or
    #  Anton Bauer ***

    value = value.sub( /^\s*(\*{1,3})\s+/ ) do |_|
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

    value = value.sub( /\s+(\*{1,3})\s*$/ ) do |_|
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

    [grade,value]
  end


  def find_key_n_title( values )  # NB: returns ary [attribs,more_values] / two values

    ## fix: add/configure logger for ActiveRecord!!!
    logger = LogKernel::Logger.root

    ### todo/fix: allow check - do NOT allow mixed use of with key and w/o key
    ##  either use keys or do NOT use keys; do NOT mix in a single fixture file

    ### support autogenerate key from first title value

    # if it looks like a key (only a-z lower case allowed); assume it's a key
    #   - also allow . in keys e.g. world.quali.america, at.cup, etc.
    #   - also allow 0-9 in keys e.g. at.2, at.3.1, etc.

    # fix/todo: add support for leading underscore _
    #   or allow keys starting w/ digits?
    
    # NB: key must start w/ a-z letter (NB: minimum one letter possible)
    if values[0] =~ /^([a-z][a-z0-9.]*[a-z0-9]|[a-z])$/
      key_col         = values[0]
      title_col       = values[1]
      more_values     = values[2..-1]
    else
      key_col         = '<auto>'
      title_col       = values[0]
      more_values     = values[1..-1]
    end

    attribs = {}

    ## check title_col for grade (e.g. ***/**/*) and use returned stripped title_col if exits
    grade, title_col = find_grade( title_col )

    # NB: for now - do NOT include default grade e.g. if grade (***/**/*) not present; attrib will not be present too
    if grade == 1 || grade == 2 || grade == 3  # grade found/present
      logger.debug "   found grade #{grade} in title"
      attribs[:grade] = grade
    end

    ## fix/todo: add find parts ??
    #  e.g. ‹Estrella› ‹Damm› Inedit
    #    becomes =>   title: 'Estrella Damm Inedit'  and  parts: ['Estrella','Damm']

    ## title (split of optional synonyms)
    # e.g. FC Bayern Muenchen|Bayern Muenchen|Bayern
    titles = title_col.split('|')

    attribs[ :title ]    =  titles[0]

    ## add optional synonyms if present
    attribs[ :synonyms ] =  titles[1..-1].join('|')  if titles.size > 1

    if key_col == '<auto>'
      ## autogenerate key from first title
      key_col = TextUtils.title_to_key( titles[0] )
      logger.debug "   autogen key »#{key_col}« from title »#{titles[0]}«"
    end

    attribs[ :key ] = key_col

    [attribs, more_values]
  end

  end # module ValueHelper
end # module TextUtils
