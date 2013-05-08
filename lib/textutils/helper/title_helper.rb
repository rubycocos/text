# encoding: utf-8


module TextUtils
  module TitleHelper

  def title_to_key( title )

   ## NB: used in/moved from readers/values_reader.rb


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
      
      alternatives.each do |alt|
        title = title.gsub( alt[0], alt[1] )
      end

      title
  end


  end # module TitleHelper
end # module TextUtils
