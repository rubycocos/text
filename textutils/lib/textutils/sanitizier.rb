# encoding: utf-8

module TextUtils

class Sanitizier

  include LogUtils::Logging

  @@ignore_tags = %w{ head script style }
  @@inline_tags = %w{ span b i u }
  @@block_tags  = %w{ p div ul ol }


  def initialize( ht )
    @ht = ht  # hypertext (html source)
  end

  def to_plain_text
    
    ht = @ht
    ht = handle_ignore_tags( ht )

## handle_pre_tags ??  - special rule for preformatted (keep whitespace)

    ht = handle_inline_tags( ht )
    ht = handle_block_tags( ht )
    ht = handle_other_tags( ht )  # rules for remain/left over tags

    ht = handle_entities( ht )

    ht
  end

  def handle_entities( ht )
    ## unescape entities
    #  - check if it also works for generic entities like &#20; etc.
    #  or only for &gt; &lt; etc.
    ht = CGI.unescapeHTML( ht )
  end

  def tag_regex( tag )
    # note use non-greedy .*? for content

    /<#{tag}[^>]*>(.*?)<\/#{tag}>/mi
  end

  def handle_ignore_tags( ht )
    @@ignore_tags.each do |tag|
      ht.gsub!( tag_regex(tag), '' )
    end
    ht
  end

  def handle_inline_tags( ht )
    @@inline_tags.each do |tag|
      # add a space after
      ht.gsub!( tag_regex(tag), '\1 ' )
    end
    ht
  end

  def handle_block_tags( ht )
    @@block_tags.each do |tag|
      ht.gsub!( tag_regex(tag), "\n\1\n" )
    end
    ht
  end


end # class Sanitizier

end # module TextUtils
