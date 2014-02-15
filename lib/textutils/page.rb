# encoding: utf-8

##
## page template class for book production w/ markdown
##   and static site compiler (e.g. jekyll)
##
## todo: move filters to filter for public reuse!!!

module TextUtils


############
## fix:
###   add some unit tests!!!!!!!!!!!!!!!!!
###

class Page

  ### convenience helper; use like:
  ##   Page.open() do |page|
  ##      page.write( text )
  ##      page.write( text )
  ##   end

  def self.open( path, mode, opts={} )
    page = self.new( path, mode, opts )
    yield( page )
    page.close
  end

  def self.create( path, opts={} )
    ## todo: check if 'w' is good enough?? do NOT need to add +
    page = self.new( path, 'w+', opts )
    yield( page )
    page.close
  end

  def self.update( path, opts={} )
    ## todo: check if 'a' is good enough?? do NOT need to add +
    page = self.new( path, 'a+', opts )
    yield( page )
    page.close
  end


  def initialize( path, mode, opts={} )
    ## check if folders exists? if not create folder in path
    FileUtils.mkdir_p( File.dirname(path) )

    @file = File.new( path, mode )

    ## add frontmatter if passed in
    ## todo: assert check if mode = 'w' and NOT 'a' !!!
    @file.write render_frontmatter( opts[:frontmatter] )  if opts[:frontmatter]
  end

  def write( text )
    @file.write( text )
  end

  def close
    @file.close
  end

private

###########################
#  helpers
#   - make public for reuse !!!!!

def render_frontmatter( h )
  buf = ''
  buf += "---\n"

  h.each do |key,value|
    buf += "#{key}: #{value}\n"
  end

  buf += "---\n\n"
  buf
end

end # class Page


class PageTemplate


###
## todo: what is the best convention for loading file and handling string
## for now it its:
#
#  PageTemplate.read( 'to/path ' )  or     --- use load ???? instead of read??
#  PageTemplate.new( 'template content'  )


def self.read( path )
  self.new( File.read_utf8( path ) )
end


def initialize( tmpl )
  @tmpl = tmpl.dup   # make a copy; just to be sure no one will change text
end

def render( ctx )
# note: erb offers the following trim modes:
#  1) <> omit newline for lines starting with <% and ending in %>
#  2)  >  omit newline for lines ending in %>
#  3)  omit blank lines ending in -%>
  ## run filters
  tmpl = remove_html_comments( @tmpl )
  tmpl = remove_blanks( tmpl )

  tmpl = django_to_erb( tmpl )  ## allow django/jinja style templates

  tmpl = remove_leading_spaces( tmpl )
  tmpl = concat_lines( tmpl )

  text = ERB.new( tmpl, nil, '<>' ).result( ctx )

  ### text = cleanup_newlines( text )
  text
end

#######################
#  filters
#   - use better names and make public for reuse!!!!

def django_to_erb( text )
  ## convert django style markers to erb style marker e.g
  #  {% %} becomes <% %>  -- supports multi-line
  #  {{ }} becomes <%= %>  - does NOT support multi-line

  ## comments (support multi-line)
  text = text.gsub( /\{#(.+?)#\}/m ) do |_|
   "<%# #{1} %>"
  end

  text = text.gsub( /\{%(.+?)%\}/m ) do |_|
    ## note: also replace newlines w/  %>\n<%  to split
    #   multi-line stmts into single-line stmts
    # lets us use
    # {%
    #  %} will become
    # <%  %>
    # <%  %>
    "<% #{$1} %>".gsub( "\n", " %>\n<% " )
  end

  # note: for now {{ }} will NOT support multi-line
  text = text.gsub( /\{\{(.+?)\}\}/ ) do |_|
    "<%= #{$1} %>"
  end

  text
end

def remove_html_comments( text )
  text.gsub( /<!--.+?-->/, '' )
end

def remove_leading_spaces( text )
  # remove leading spaces if less than four !!!
  text.gsub( /^[ \t]+(?![ \t])/, '' )    # use negative regex lookahead e.g. (?!)
end

def remove_blanks( text )
  # remove lines only with  ..
  text.gsub( /^[ \t]*\.{2}[ \t]*\n/, '' )
end

def cleanup_newlines( text )
  # remove all blank lines that go over three
  text.gsub( /\n{4,}/, "\n\n\n" )
end


def concat_lines( text )
  #  lines ending with  ++  will get newlines get removed
  # e.g.
  # >|   hello1 ++
  # >1   hello2
  #  becomes
  # >|   hello1 hello2
  
  #
  # note: do NOT use \s - will include \n (newline) ??
  
  text.gsub( /[ \t]+\+{2}[ \t]*\n[ \t]*/, ' ' )  # note: replace with single space
end


end # class PageTemplate

end # module TextUtils

