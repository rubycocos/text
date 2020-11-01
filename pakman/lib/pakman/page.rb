# encoding: utf-8

module Pakman


## Jekyll-style page
##   with optional front-matter (yaml block)

class Page

  def self.from_file( path )
    puts "  Loading page (from file) >#{path}<..."
    text = File.open( path, 'r:bom|utf-8' ).read     ## note: assume utf8
    self.new( text, path: path )   ## note: pass along path as an option
  end

  def self.from_string( text )  ### use parse as alias - why?? why not??
    self.new( text )
  end

  attr_reader :contents
  attr_reader :headers

  ## has headers/metadata (front matter block) - yes/no - use hash for check for now
  def headers?()  @headers.kind_of?( Hash ); end

  ## check if \s includes newline too?
  ## fix/check ^ - just means start of newline (use /A or something --- MUST always be first
  ##
  ##  note: include --- in headers
  ##    e.g. ---  results in nil
  ##         empty string (without leading ---) results in false! (we want nil if no headers for empty block)
  HEADERS_PATTERN = /
      ^(?<headers>---\s*\n
         .*?)
      ^(---\s*$\n?)
     /xm

  def initialize( text, opts={} )
    ## todo/fix: check regex in jekyll (add link to source etc.)
    if m=HEADERS_PATTERN.match( text )
      @contents  = m.post_match
      pp m
      pp m[:headers]
      @headers  = YAML.load( m[:headers] )
      pp @headers
      @headers = {}  if @headers.nil?  ##  check if headers is nil use/assign empty hash
    else
      @contents = text
      @headers  = nil
    end
  end

end # class Page
end # module Pakman
