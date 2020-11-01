# encoding: utf-8

module Pakman


class LiquidTemplate

  def self.from_file( path )
    puts "  Loading template (from file) >#{path}<..."
    text = File.open( path, 'r:bom|utf-8' ).read     ## note: assume utf8
    self.new( text, path: path )   ## note: pass along path as an option
  end

  def self.from_string( text )  ### use parse as alias - why?? why not??
    self.new( text )
  end

  def initialize( text, opts={} )
    @template = Liquid::Template.parse( text )   # parses and compiles the template
  end

  def render( hash )
    ## note: hash keys MUST be strings (not symbols) e.g. 'name' => 'Toby'
    ## pp hash
    res = @template.render( hash,  { strict_variables: true, strict_filters: true } )

    ###
    ##  issue warnings/errors if present
    errors = @template.errors
    if errors.size > 0
      puts "!! WARN - #{errors.size} liquid error(s) when rendering template:"
      pp errors
    end

    res
  end

end # class LiquidTemplate


#########################
## convenience helper for pages (with headers/front matter)

class LiquidPageTemplate
  def self.from_file( path )
    ## todo: (auto)-add headers as page.title etc. -- why? why not??
    puts "  Loading page template (from file) >#{path}<..."
    page = Page.from_file( path )     ## use/todo: use read utf8 - why? why not??
    self.new( page.contents, path: path )   ## note: pass along path as an option
  end

  def self.from_string( text )  ### use parse as alias - why?? why not??
    ## todo: (auto)-add headers as page.title etc. -- why? why not??
    page = Page.from_string( text )
    self.new( page.contents )
  end

  def initialize( text, opts={} )
    @template = LiquidTemplate.new( text, opts )
  end

  def render( hash )
    @template.render( hash )
  end

end ## class LiquidPageTemplate


end # module Pakman
