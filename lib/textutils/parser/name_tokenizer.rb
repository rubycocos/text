# encoding: utf-8

# fix: move into TextUtils namespace/module!! ??


class NameTokenizer   ## - rename to NameScanner, NameSplitter, NameSeparator, etc.

  ## split (single) string value into array of names
  ##   e.g.
  ##   'München [Munich]'             => ['München', '[Munich]']
  ##   'Wr. Neustadt | Wiener Neustadt' => ['Wr. Neustadt', 'Wiener Neustadt']
  include LogUtils::Logging

  def tokenize( value )   ## rename to/use split - why? why not??
    names = []

    # 1)  split by | (pipe) -- remove leading n trailing whitespaces
    parts = value.split( /[ \t]*\|[ \t]*/ )

    # 2)  split "inline" translations e.g. München [Munich]

    ## todo: add support for  Munich [en]  e.g. trailing lang tag
    ## todo: add support for bullet (official bi-lingual names w/ tags ??) - see brussels - why, why not??

    parts.each do |part|
        s = StringScanner.new( part )
        s.skip( /[ \t]+/)   # skip whitespaces

        while s.eos? == false
          if s.check( /\[/ )
            ## scan everything until the end of bracket (e.g.])
            name = s.scan( /\[[^\]]+\]/)
            ## todo/fix: if name nil - issue warning??
            #  starting w/ [  but no closing ] found !!!! - possible? fix!!
          else
            ## scan everything until the begin of bracket (e.g.[)
            name = s.scan( /[^\[]+/)
            name = name.rstrip   ## remove trailing spaces (if present)
          end
          names << name

          s.skip( /[ \t]+/)  # skip whitespaces
          logger.debug( "[NameTokenizer] eos?: #{s.eos?}, rest: >#{s.rest}<" )
        end
    end # each part

    logger.debug( "[NameTokenizer] names=#{names.inspect}")
    names
  end # method split
end # class NameTokenizer

