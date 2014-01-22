# encoding: utf-8


module TextUtils
  module TitleHelper

####
# - todo: use new additional sub module ???
#     e.g. TextUtils::Reader::TagHelper
#   lets us use "classic" web helpers a la rails
#   find a good name for sub module -  Reader? Fixtures? Values? Parser? 

  def strip_part_markers( title )   # use different name e.g. strip_name_markers/strip_name_enclosure etc.??
     # remove optional part markers
     # e.g. Bock ‹Damm› becomes =>  Bock Damm
     #      ‹Estrella› ‹Damm› Inedit becomes =>  Estrella Damm Inedit

     title.gsub( /[<>‹›]/, '' )
  end

  def strip_translations( title )
      # remove optional english translation in square brackets ([])
      # e.g. Wien [Vienna]  =>  Wien

      title.gsub( /\[[^\]]+\]/, '' )
  end

  def strip_subtitles( title )
      # remove optional longer title part in ()
      # e.g. Las Palmas (de Gran Canaria) => Las Palmas
      #      Palma (de Mallorca) => Palma

      title.gsub( /\([^\)]+\)/, '' )
  end

  def strip_tags( title )   # todo: use an alias or rename for better name ??
      # remove optional longer title part in {}
      #  e.g. Ottakringer {Bio}   => Ottakringer
      #       Ottakringer {Alkoholfrei} => Ottakringer
      #
      # todo: use for autotags? e.g. {Bio} => bio 
      
      title.gsub( /\{[^\}]+\}/, '' )
  end

  def strip_whitespaces( title )
      # remove all whitespace and punctuation
      title.gsub( /[ \t_\-\.!()\[\]'"\/]/, '' )
  end

  def strip_special_chars( title )
      # remove special chars (e.g. %°&)
      # e.g. +Malta
      #      Minerva 8:60
      title.gsub( /[%&°+:]/, '' )
  end

  def title_to_key( title )

      ## NB: used in/moved from readers/values_reader.rb

      ## NB: downcase does NOT work for accented chars (thus, include in alternatives)
      key = title.downcase

      key = strip_part_markers( key )  # e.g. ‹Estrella› ‹Damm› Inedit becomes =>  Estrella Damm Inedit

      key = strip_translations( key )

      key = strip_subtitles( key )

      key = strip_tags( key )

      key = strip_whitespaces( key )

      key = strip_special_chars( key )

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
        ['ù', 'u' ],  # e.g. Xyauyù (it)
        ['ū', 'u' ],  # e.g. Sūduva
        ['ů', 'u' ],  # e.g. Sládkův
        ['ı', 'u' ],  # e.g. Bakı   # use u?? (Baku) why-why not?
        ['ý', 'y' ],  # e.g. Nefitrovaný
        ['ź', 'z' ],  # e.g. Łódź
        ['ž', 'z' ],  # e.g. Domžale, Petržalka
        ['ż', 'z' ],  # e.g. Lomża  (polish)

        ['Á', 'a' ],  # e.g. Águila (es)
        ['Č', 'c' ],  # e.g. České
        ['İ', 'i' ],  # e.g. İnter
        ['Í', 'i' ],  # e.g. ÍBV
        ['Ł', 'l' ],  # e.g. Łódź
        ['Ö', 'oe' ], # e.g. Örebro
        ['Ø', 'o' ],  # e.g. Nogne Ø Imperial Stout (no)
        ['Ř', 'r' ],  # e.g. Řezák
        ['Ś', 's' ],  # e.g. Śląsk
        ['Š', 's' ],  # e.g. MŠK
        ['Ş', 's' ],  # e.g. Şüvälan
        ['Ú', 'u' ],  # e.g. Ústí, Újpest
        ['Ž', 'z' ],   # e.g. Žilina
        ['Ż', 'z' ]    # e.g. Żywiec (polish)
      ]
      
      alternatives.each do |alt|
        key = key.gsub( alt[0], alt[1] )
      end

      key
  end # method title_to_key


  def title_esc_regex( title_unescaped )
      
      ##  escape regex special chars e.g. . to \. and ( to \( etc.
      # e.g. Benfica Lis.
      # e.g. Club Atlético Colón (Santa Fe)

      ## NB: cannot use Regexp.escape! will escape space '' to '\ '
      ## title = Regexp.escape( title_unescaped )
      title = title_unescaped.gsub( '.', '\.' )
      title = title.gsub( '(', '\(' )
      title = title.gsub( ')', '\)' )

      ##  match accented char with or without accents
      ##  add (ü|ue) etc.
      ## also make - optional change to (-| ) e.g. Blau-Weiss == Blau Weiss

      ## todo: add some more
      ## see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references  for more
      ##
      ##  reuse for all readers!
      
      alternatives = [
        ['-', '(-| )'],  ## e.g. Blau-Weiß Linz
        ['æ', '(æ|ae)'],  ## e.g. 
        ['á', '(á|a)'],  ## e.g. Bogotá, Sársfield
        ['ã', '(ã|a)'],  ## e.g  São Paulo
        ['ä', '(ä|ae)'],  ## e.g. 
        ['ç', '(ç|c)'],  ## e.g. Fenerbahçe
        ['é', '(é|e)'],  ## e.g. Vélez
        ['ê', '(ê|e)'],  ## e.g. Grêmio
        ['ñ', '(ñ|n)'],  ## e.g. Porteño
        ['ň', '(ň|n)'],  ## e.g. Plzeň
        ['Ö', '(Ö|Oe)'], ## e.g. Österreich
        ['ö', '(ö|oe)'],  ## e.g. Mönchengladbach
        ['ó', '(ó|o)'],   ## e.g. Colón
        ['ș', '(ș|s)'],   ## e.g. Bucarești
        ['ß', '(ß|ss)'],  ## e.g. Blau-Weiß Linz
        ['ü', '(ü|ue)'],  ## e.g. 
        ['ú', '(ú|u)']  ## e.g. Fútbol
      ]
      
      ### fix/todo:  check for  dot+space e.g. . and make dot optional
      ##    e.g. U. de. G. or U de G or U.de.G ??
      ##   collect some more (real-world) examples first!!!!!
      
      alternatives.each do |alt|
        title = title.gsub( alt[0], alt[1] )
      end

      title
  end


  end # module TitleHelper
end # module TextUtils
