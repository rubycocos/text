# encoding: utf-8

module TextUtils
  module HypertextHelper


def strip_tags( ht )
  ### to be done
  ## strip markup tags; return plain text; use brute force for now
  # check at least for presence of required a-z+ tag names
  #
  #  note: make sure we cover h1/h2/h3/h4/h5/h6  tag w/ number!!

  ### ht.gsub( /<[^>]+>/, '' ) - old simple

  ## todo: add strip comments e.g. <!-- xxxx --> ???
  ##  or use new strip_comments( ht )


  ## note: follow offical xml spec
  ##  - allows for first char:  (Letter | '_' | ':')
  ##  - allows for followup chars: (Letter | Digit | '_' | ':' | '.' | '-')

  tag_name_pattern = "[a-z_:][a-z0-9_:.\\-]*"

  empty_tag_pattern   =  "<#{tag_name_pattern}\\s*/>"
  opening_tag_pattern =  "<#{tag_name_pattern}(\\s+[^>]*)?>"
  closing_tag_pattern =  "</#{tag_name_pattern}\\s*>"

  ht = ht.gsub( /#{empty_tag_pattern}/i, '' )    # remove xml-style empty tags eg. <br /> or <br/>
  ht = ht.gsub( /#{opening_tag_pattern}/i, '' )  # opening tag <p>
  ht = ht.gsub( /#{closing_tag_pattern}/i, '' )  # closing tag e.g. </p>
  ht
end


def whitelist( ht, tags, opts={} )

  # note: assumes properly escaped <> in ht/hypertext

  ###############################################
  # step one - save whitelisted tags use ‹tag›
  tags.each do |tag|
    # note: we strip all attribues
    # note: match all tags case insensitive e.g. allow a,A or br,BR,bR etc.
    #   downcase all tags

    # convert xml-style empty tags to simple html emtpty tags
    #  e.g. <br/> or <br /> becomses <br>
    ht = ht.gsub( /<(#{tag})\s*\/>/i )       { |_| "‹#{$1.downcase}›" }   # eg. <br /> or <br/> becomes ‹br›

    # make sure we won't swall <br> for <b> for example, thus use \s+ before [^>]
    ht = ht.gsub( /<(#{tag})(\s+[^>]*)?>/i ) { |_| "‹#{$1.downcase}›" }   # opening tag <p>
    ht = ht.gsub( /<\/(#{tag})\s*>/i )       { |_| "‹/#{$1.downcase}›" }  # closing tag e.g. </p>
  end

  ############################
  # step two - clean tags

  #   strip images - special treatment for debugging
  ht = ht.gsub( /<img[^>]*>/i, '♦' )   # for debugging use black diamond e.g. ♦
  ht = ht.gsub( /<\/img>/i, '' )   # should not exists

  # strip all remaining tags
  #  -- note: will NOT strip comments for now e.g. <!-- -->
  ht = strip_tags( ht )

  ## pp ht  # fix: debugging indo - remove

  ############################################
  # step three - restore whitelisted tags

  return ht   if opts[:skip_restore]   # skip step 3 for debugging

  tags.each do |tag|
#      ht = ht.gsub( /‹(#{tag})›/, "<\1>" )  # opening tag e.g. <p>
#      ht = ht.gsub( /‹\/(#{tag})›/, "<\/\1>" )  # closing tag e.g. </p>
    ht = ht.gsub( /‹(#{tag})›/ )   { |_| "<#{$1}>" }
    ht = ht.gsub( /‹\/(#{tag})›/ ) { |_| "<\/#{$1}>" }  # closing tag e.g. </p>
  end

  ht
end  # method whitelist




##  change to simple_hypertext or
#     hypertext_simple or
#     sanitize ???

def sanitize( ht, opts={} )  # ht -> hypertext
  # todo: add options for
  #   keep links, images, lists (?too), code, codeblocks

  ht = whitelist( ht, [:br, :p, :ul, :ol, :li, :pre, :code, :blockquote, :q, :cite], opts )

# clean (prettify) literal urls (strip protocoll) 
  ht = ht.gsub( /(http|https):\/\//, '' )
  ht
end


def textify( ht, opts={} )   # ht -> hypertext
  ## turn into plain (or markdown/wiki-style) text - to be done

  sanitize( ht, opts )   # step 1 - sanitize html
  # to be done

# strip bold
#    ht = ht.gsub( /<b[^>]*>/, '**' )  # fix: will also swallow bxxx tags - add b space
#    ht = ht.gsub( /<\/b>/, '**' )

# strip em
#   ht = ht.gsub( /<em[^>]*>/, '__' )
#   ht = ht.gsub( /<\/em>/, '__' )

#    ht = ht.gsub( /&nbsp;/, ' ' )

#    # try to cleanup whitespaces
#    # -- keep no more than two spaces
#    ht = ht.gsub( /[ \t]{3,}/, '  ' )
#    # -- keep no more than two new lines
#    ht = ht.gsub( /\n{2,}/m, "\n\n" ) 
#    # -- remove all trailing spaces
#    ht = ht.gsub( /[ \t\n]+$/m, '' )
#    # -- remove all leading spaces
#    ht = ht.gsub( /^[ \t\n]+/m, '' )
end


##############################
#  rails-style asset, url tag helpers and friends
#
#  todo:  move into different helper module/modules?? why? why not?

def tag( tag, opts={} )  # empty tag (no content e.g. <br>, <img src=''> etc.)
  attribs  = []
  opts.each do |key,value|
    attribs << "#{key}='#{value}'"
  end
  
  if attribs.size > 0
    "<#{tag} #{attribs.join(' ')}>"
  else
    "<#{tag}>"
  end
end

def content_tag( tag, content, opts={} ) # content tag (e.g. <p>hello</p> - w/ opening and closing tag)
  attribs = []
  opts.each do |key,value|
    attribs << "#{key}='#{value}'"
  end
  
  if attribs.size > 0
    "<#{tag} #{attribs.join(' ')}>#{content}</#{tag}>"
  else
    "<#{tag}>#{content}</#{tag}>"
  end
end


def stylesheet_link_tag( href, opts={} )
  href = "#{href}.css"  unless href.end_with?( '.css' )   # auto-add .css if not present
  attribs = { rel:  'stylesheet',
              type: 'text/css',
              href: href }
  attribs = attribs.merge( opts )  ### fix/todo: use reverse merge e.g. overwrite only if not present
  tag( :link, attribs )
end

def image_tag( src, opts={} )
  attribs = { src: src }
  attribs = attribs.merge( opts )  ### fix/todo: use reverse merge e.g. overwrite only if not present
  tag( :img, attribs )   ### "<img src='#{src}' #{attributes}>"
end

def link_to( content, href, opts={} )
  attribs = { href: href }
  attribs = attribs.merge( opts )  ### fix/todo: use reverse merge e.g. overwrite only if not present
  content_tag( :a, content, attribs )  ### "<a href='#{href}' #{attributes}>#{text}</a>"
end


  end # module HypertextHelper
end # module TextUtils
