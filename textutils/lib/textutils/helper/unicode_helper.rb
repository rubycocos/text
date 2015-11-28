# encoding: utf-8


module TextUtils
  module UnicodeHelper

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


  end # module UnicodeHelper
end # module TextUtils
