# encoding: utf-8


class File
  def self.read_utf8( path )
    text = open( path, 'r:bom|utf-8' ) do |file|
      file.read
    end

    # NB: for convenience: convert fancy unicode dashes/hyphens to plain ascii hyphen-minus
    text = convert_unicode_dashes_to_plain_ascii( text, path: path )

    text
  end
end # class File


# NB:
#  U_HYPHEN_MINUS is standard ascii hyphen/minus e.g. -
#
#  see en.wikipedia.org/wiki/Dash

U_HYPHEN              = "\u2010"  # unambigous hyphen
U_NON_BREAKING_HYPHEN = "\u2011"  # unambigous non-breaking hyphen
U_MINUS               = "\u2212"  # unambigous minus sign (html => &minus;)
U_NDASH               = "\u2013"  # ndash (html => &ndash; ascii => --)
U_MDASH               = "\u2014"  # mdash (html => &mdash; ascii => ---)


  def convert_unicode_dashes_to_plain_ascii( text, opts = {} )
    
    text = text.gsub( /(#{U_HYPHEN}|#{U_NON_BREAKING_HYPHEN}|#{U_MINUS}|#{U_NDASH}|#{U_MDASH})/ ) do |_|

      # puts "found U+#{'%04X' % $1.ord} (#{$1})"

      msg = ''

      if $1 == U_HYPHEN
        msg << "found hyhpen U+2010 (#{$1})"
      elsif $1 == U_NON_BREAKING_HYPHEN
        msg << "found non_breaking_hyhpen U+2011 (#{$1})"
      elsif $1 == U_MINUS
        msg << "found minus U+2212 (#{$1})"
      elsif $1 == U_NDASH
        msg << "found ndash U+2013 (#{$1})"
      elsif $1 == U_MDASH
        msg << "found mdash U+2014 (#{$1})"
      else
        msg << "found unknown unicode dash U+#{'%04X' % $1.ord} (#{$1})"
      end

      msg << " in file >#{opts[:path]}<"   if opts[:path]
      msg << "; converting to plain ascii hyphen_minus (-)"
  
      puts "*** warning: #{msg}"

      '-'
    end

    text
  end # method convert_unicode_dashes_to_plain_ascii


  ############
  ### fix/todo: share helper for all text readers/parsers- where to put it?  
  ###
  
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
