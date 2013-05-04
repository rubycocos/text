# encoding: utf-8

class ValuesReader

  include LogUtils::Logging

  def initialize( path, more_values={} )
    @path = path

    @more_values = more_values

    @data = File.read_utf8( @path )
  end

  def each_line
   
    @data.each_line do |line|
  
      ## allow alternative comment lines
      ## e.g. -- comment or
      ##      % comment
      ##  why?  # might get used by markdown for marking headers, for example

      ## NB: for now alternative comment lines not allowed as end of line style e.g
      ##  some data, more data   -- comment here

      if line =~ /^\s*#/ || line =~ /^\s*--/ || line =~ /^\s*%/
        # skip komments and do NOT copy to result (keep comments secret!)
        logger.debug 'skipping comment line'
        next
      end

      if line =~ /^\s*$/
        # kommentar oder leerzeile überspringen 
        logger.debug 'skipping blank line'
        next
      end


      # pass 1) remove possible trailing eol comment
      ##  e.g    -> nyc, New York   # Sample EOL Comment Here (with or without commas,,,,)
      ## becomes -> nyc, New York

      line = line.sub( /\s+#.+$/, '' )

      # pass 2) remove leading and trailing whitespace
      
      line = line.strip

      ### guard escaped commas (e.g. \,)
      line = line.gsub( '\,', '@commma@' )
      
      ## use generic separator (allow us to configure separator)
      line = line.gsub( ',', '@sep@')
      
      ## restore escaped commas (before split)
      line = line.gsub( '@commma@', ',' )


      logger.debug "line: >>#{line}<<"

      values = line.split( '@sep@' )
      
      # pass 1) remove leading and trailing whitespace for values

      values = values.map { |value| value.strip }

      ##### todo remove support of comment column? (NB: must NOT include commas)
      # pass 2) remove comment columns
      
      values = values.select do |value|
        if value =~ /^#/  ## start with # treat it as a comment column; e.g. remove it
          logger.debug "   removing column with value >>#{value}<<"
          false
        else
          true
        end
      end
      
      logger.debug "  values: >>#{values.join('<< >>')}<<"
      
      
      ### todo/fix: allow check - do NOT allow mixed use of with key and w/o key
      ##  either use keys or do NOT use keys; do NOT mix in a single fixture file
      
      
      ### support autogenerate key from first title value
      
      # if it looks like a key (only a-z lower case allowed); assume it's a key
      #   - also allow . in keys e.g. world.quali.america, at.cup, etc.
      #   - also allow 0-9 in keys e.g. at.2, at.3.1, etc.

      # fix/todo: add support for leading underscore _
      #   or allow keys starting w/ digits?
      if values[0] =~ /^([a-z][a-z0-9.]*[a-z0-9]|[a-z])$/    # NB: key must start w/ a-z letter (NB: minimum one letter possible)
        key_col         = values[0]
        title_col       = values[1]
        more_cols       = values[2..-1]
      else
        key_col         = '<auto>'
        title_col       = values[0]
        more_cols       = values[1..-1]
      end

      attribs = {}

      ## title (split of optional synonyms)
      # e.g. FC Bayern Muenchen|Bayern Muenchen|Bayern
      titles = title_col.split('|')
      
      attribs[ :title ]    =  titles[0]
     
      ## add optional synonyms if present
      attribs[ :synonyms ] =  titles[1..-1].join('|')  if titles.size > 1
      
      if key_col == '<auto>'
        ## autogenerate key from first title
        key_col = title_to_key( titles[0] )
        logger.debug "   autogen key >#{key_col}< from title >#{titles[0]}<, textutils version #{TextUtils::VERSION}"
      end
      
      attribs[ :key ] = key_col
      
      attribs = attribs.merge( @more_values )  # e.g. merge country_id and other defaults if present
                        
      yield( attribs, more_cols )

    end # each lines

  end # method each_line
  
  

  def title_to_key( title )

      ## NB: downcase does NOT work for accented chars (thus, include in alternatives)
      key = title.downcase

      ### remove optional english translation in square brackets ([]) e.g. Wien [Vienna]
      key = key.gsub( /\[.+\]/, '' )

      ## remove optional longer title part in () e.g. Las Palmas (de Gran Canaria), Palma (de Mallorca)
      key = key.gsub( /\(.+\)/, '' )
      
      ## remove optional longer title part in {} e.g. Ottakringer {Bio} or {Alkoholfrei}
      ## todo: use for autotags? e.g. {Bio} => bio 
      key = key.gsub( /\{.+\}/, '' )

      ## remove all whitespace and punctuation
      key = key.gsub( /[ \t_\-\.()\[\]'"\/]/, '' )

      ## remove special chars (e.g. %°&)
      key = key.gsub( /[%&°]/, '' )

      ##  turn accented char into ascii look alike if possible
      ##
      ## todo: add some more
      ## see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references  for more
      
      ## todo: add unicode codepoint name
      
      alternatives = [
        ['ß', 'ss'],
        ['æ', 'ae'],
        ['ä', 'ae'],
        ['ā', 'a' ],  # e.g. Liepājas
        ['á', 'a' ],  # e.g. Bogotá, Králové
        ['ã', 'a' ],  # e.g  São Paulo
        ['ă', 'a' ],  # e.g. Chișinău
        ['â', 'a' ],  # e.g  Goiânia
        ['å', 'a' ],  # e.g. Vålerenga
        ['ą', 'a' ],  # e.g. Śląsk
        ['ç', 'c' ],  # e.g. São Gonçalo, Iguaçu, Neftçi
        ['ć', 'c' ],  # e.g. Budućnost
        ['č', 'c' ],  # e.g. Tradiční, Výčepní
        ['é', 'e' ],  # e.g. Vélez, Králové
        ['è', 'e' ],  # e.g. Rivières
        ['ê', 'e' ],  # e.g. Grêmio
        ['ě', 'e' ],  # e.g. Budějovice
        ['ĕ', 'e' ],  # e.g. Svĕtlý
        ['ė', 'e' ],  # e.g. Vėtra
        ['ë', 'e' ],  # e.g. Skënderbeu
        ['ğ', 'g' ],  # e.g. Qarabağ
        ['ì', 'i' ],  # e.g. Potosì
        ['í', 'i' ],  # e.g. Ústí
        ['ł', 'l' ],  # e.g. Wisła, Wrocław
        ['ñ', 'n' ],  # e.g. Porteño
        ['ň', 'n' ],  # e.g. Plzeň, Třeboň
        ['ö', 'oe'],
        ['ő', 'o' ],  # e.g. Győri
        ['ó', 'o' ],  # e.g. Colón, Łódź, Kraków
        ['õ', 'o' ],  # e.g. Nõmme
        ['ø', 'o' ],  # e.g. Fuglafjørdur, København
        ['ř', 'r' ],  # e.g. Třeboň
        ['ș', 's' ],  # e.g. Chișinău, București
        ['ş', 's' ],  # e.g. Beşiktaş
        ['š', 's' ],  # e.g. Košice
        ['ť', 't' ],  # e.g. Měšťan
        ['ü', 'ue'],
        ['ú', 'u' ],  # e.g. Fútbol
        ['ū', 'u' ],  # e.g. Sūduva
        ['ů', 'u' ],  # e.g. Sládkův
        ['ı', 'u' ],  # e.g. Bakı   # use u?? (Baku) why-why not?
        ['ý', 'y' ],  # e.g. Nefitrovaný
        ['ź', 'z' ],  # e.g. Łódź
        ['ž', 'z' ],  # e.g. Domžale, Petržalka

        ['Č', 'c' ],  # e.g. České
        ['İ', 'i' ],  # e.g. İnter
        ['Í', 'i' ],  # e.g. ÍBV
        ['Ł', 'l' ],  # e.g. Łódź
        ['Ö', 'oe' ], # e.g. Örebro
        ['Ř', 'r' ],  # e.g. Řezák
        ['Ś', 's' ],  # e.g. Śląsk
        ['Š', 's' ],  # e.g. MŠK
        ['Ş', 's' ],  # e.g. Şüvälan
        ['Ú', 'u' ],  # e.g. Ústí, Újpest
        ['Ž', 'z' ]   # e.g. Žilina
      ]
      
      alternatives.each do |alt|
        key = key.gsub( alt[0], alt[1] )
      end

      key
  end # method title_to_key

end # class ValuesReader