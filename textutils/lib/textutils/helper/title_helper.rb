# encoding: utf-8


###
#
# fix: move to filter!!!!
#   follows   fn( content ) pattern!!!


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
      title.gsub( /[ \t_\-\.!()\[\]'"’\/]/, '' )
  end

  def strip_special_chars( title )
      # remove special chars (e.g. %°&$)
      # e.g. +Malta
      #      Minerva 8:60
      #      $Alianz$ Arena
      title.gsub( /[%&°+:$]/, '' )
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

      key = TextUtils.asciify( key ).downcase  ## see filter/string_filter

      key
  end # method title_to_key


  def title_esc_regex( title_unescaped )
      
      ##  escape regex special chars e.g.
      #    . to \. and
      #    ( to \(
      #    ) to \)
      #    ? to \? -- zero or one
      #    * to \* -- zero or more
      #    + to \+ -- one or more
      #    $ to \$ -- end of line
      #    ^ to \^ -- start of line etc.
      
      ### add { and } ???
      ### add [ and ] ???
      ### add \ too ???
      ### add | too ???

      # e.g. Benfica Lis.
      # e.g. Club Atlético Colón (Santa Fe)
      # e.g. Bauer Anton (????)

      ## NB: cannot use Regexp.escape! will escape space '' to '\ '
      ## title = Regexp.escape( title_unescaped )
      title = title_unescaped.gsub( '.', '\.' )
      title = title.gsub( '(', '\(' )
      title = title.gsub( ')', '\)' )
      title = title.gsub( '?', '\?' )
      title = title.gsub( '*', '\*' )
      title = title.gsub( '+', '\+' )
      title = title.gsub( '$', '\$' )
      title = title.gsub( '^', '\^' )

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
        ['ä', '(ä|ae)'],  ## e.g. 
        ['Ö', '(Ö|Oe)'],  ## e.g. Österreich
        ['ö', '(ö|oe)'],  ## e.g. Mönchengladbach
        ['ß', '(ß|ss)'],  ## e.g. Blau-Weiß Linz
        ['ü', '(ü|ue)'],  ## e.g. 

        ['á', '(á|a)'],  ## e.g. Bogotá, Sársfield
        ['ã', '(ã|a)'],  ## e.g  São Paulo
        ['ç', '(ç|c)'],  ## e.g. Fenerbahçe
        ['é', '(é|e)'],  ## e.g. Vélez
        ['ê', '(ê|e)'],  ## e.g. Grêmio
        ['ï', '(ï|i)' ], ## e.g. El Djazaïr
        ['ñ', '(ñ|n)'],  ## e.g. Porteño
        ['ň', '(ň|n)'],  ## e.g. Plzeň
        ['ó', '(ó|o)'],   ## e.g. Colón
        ['ō', '(ō|o)'],  # # e.g. Tōkyō
        ['ș', '(ș|s)'],   ## e.g. Bucarești
        ['ú', '(ú|u)']  ## e.g. Fútbol
      ]

      ### fix/todo:  check for  dot+space e.g. . and make dot optional
      ##
      #  e.g. make  dot (.) optional plus allow alternative optional space e.g.
      #   -- for U.S.A. => allow USA or U S A
      #
      ##    e.g. U. de G. or U de G or U.de G. ??
      ##   collect some more (real-world) examples first!!!!!

      alternatives.each do |alt|
        title = title.gsub( alt[0], alt[1] )
      end

      title
  end


  end # module TitleHelper
end # module TextUtils
