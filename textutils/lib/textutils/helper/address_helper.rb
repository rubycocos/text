# encoding: utf-8


module TextUtils
  module AddressHelper

  def normalize_addr( old_address, country_key=nil )

    # for now only checks german (de) 5-digit zip code and
    #                    austrian (at) 4-digit zip code
    #
    #  e.g.  Alte Plauener Straße 24 // 95028 Hof  becomes
    #        95028 Hof // Alte Plauener Straße 24 

    if country_key.nil?
      puts "TextUtils.normalize_addr drepreciated call - country_key now required; please add !!"
      return old_address
    end
    
    new_address = old_address   # default - do nothing - just path through
    
    lines = old_address.split( '//' )
    
    if lines.size == 2   # two lines / check for switching lines
      
      line1 = lines[0].strip
      line2 = lines[1].strip

      regex_nnnn  = /^[0-9]{4}\s+/   # four digits postal code
      regex_nnnnn = /^[0-9]{5}\s+/   # five digits postal code

      if (country_key == 'at' && line2 =~ regex_nnnn ) ||
         (country_key == 'de' && line2 =~ regex_nnnnn )
        new_address = "#{line2} // #{line1}"
      end
    end

    new_address
  end


  def find_city_in_addr_without_postal_code( address )

    ## general rule; not country-specific; no postal code/zip code or state
    #  - must be like two lines (one line empty) e.g.
    #  // London   or
    # London //
    #  will assume entry is city
    #  note: city may NOT include numbers, or pipe (|) or comma (,) chars

    # fix: use blank?
    return nil if address.nil? || address.empty?    # do NOT process nil or empty address lines; sorry

    old_lines = address.split( '//' )

    ###
    # note:   London //   will get split into arry with size 1 e.g. ['London ']
    #   support it, that is, add missing empty line

    # 1) strip lines
    # 2) remove blank lines
    lines = []
    
    old_lines.each do |line|
      linec = line.strip
      next if linec.empty?
      lines << linec
    end

    if lines.size == 1
      linec = lines[0]
        #  note: city may NOT include
        #   numbers  (e.g. assumes zip/postal code etc.) or
        #   pipe (|) or
        #   comma (,)
      if linec =~ /[0-9|,]/
        return nil
      end
        #   more than two uppercase letters e.g. TX NY etc.
        #  check if city exists wit tow uppercase letters??
      if linec =~ /[A-Z]{2,}/
        return nil
      end
      return linec   # bingo!!! assume candidate line is a city name
    end

    nil  # no generic city match found
  end


  def find_city_in_addr_with_postal_code( address, country_key )

    # fix: use blank?
    return nil if address.nil? || address.empty?    # do NOT process nil or empty address lines; sorry

    lines = address.split( '//' )

    if country_key == 'at' || country_key == 'be'
      # support for now
      #  - 2018 Antwerpen or 2870 Breendonk-Puurs (be)
      lines.each do |line|
        linec = line.strip
        regex_nnnn = /^[0-9]{4}\s+/ 
        if linec =~ regex_nnnn   # must start w/ four digit postal code ? assume its the city line
          return linec.sub( regex_nnnn, '' )  # cut off leading postal code; assume rest is city
        end
      end
    elsif country_key == 'de'
      lines.each do |line|
        linec = line.strip
        regex_nnnnn = /^[0-9]{5}\s+/
        if linec =~ regex_nnnnn   # must start w/ five digit postal code ? assume its the city line
          return linec.sub( regex_nnnnn, '' )  # cut off leading postal code; assume rest is city
        end
      end
    elsif country_key == 'cz' || country_key == 'sk'
      # support for now
      #  - 284 15  Kutná Hora or  288 25  Nymburk (cz)
      #  - 036 42  Martin     or  974 05  Banská Bystrica (sk)
      lines.each do |line|
        linec = line.strip
        regex_nnn_nn = /^[0-9]{3}\s[0-9]{2}\s+/
        if linec =~ regex_nnn_nn   # must start w/ five digit postal code ? assume its the city line
          return linec.sub( regex_nnn_nn, '' )  # cut off leading postal code; assume rest is city
        end
      end
    elsif country_key == 'us'
      # support for now
      #  - Brooklyn | NY 11249  or Brooklyn, NY 11249
      #  - Brooklyn | NY   or Brooklyn, NY

      lines.each do |line|
        linec = line.strip
        regexes_us = [/\s*[|,]\s+[A-Z]{2}\s+[0-9]{5}\s*$/,
                      /\s*[|,]\s+[A-Z]{2}\s*$/]
        
        regexes_us.each do |regex|
          if linec =~ regex
            return linec.sub( regex, '' )  # cut off leading postal code; assume rest is city
          end
        end
      end
    else
      # unsupported country/address schema for now; sorry
    end
    return nil   # sorry nothing found
  end


  def find_city_in_addr( address, country_key )

    # fix: use blank?
    return nil if address.nil? || address.empty?    # do NOT process nil or empty address lines; sorry

    ## try geneneric rule first (e.g. w/o postal code/zip code or state), see above
    city = find_city_in_addr_without_postal_code( address )
    return city unless city.nil?
    
    city = find_city_in_addr_with_postal_code( address, country_key )
    return city unless city.nil?

    nil # sorry; no city found (using known patterns)
  end


  end # module AddressHelper
end # module TextUtils
