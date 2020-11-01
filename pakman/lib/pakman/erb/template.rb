# encoding: utf-8

module Pakman

class ErbTemplate

  def self.from_file( path )
    ## todo/fix: update logutils - (auto-)add ("static") logger helper/mixin too!!!!!
    LogKernel::Logger[ self ].info "  Loading template (from file) >#{path}<..."
    text = File.open( path, 'r:bom|utf-8' ).read     ## note: assume utf8
    self.new( text, path: path )   ## note: pass along path as an option
  end

  def self.from_string( text )  ### use parse as alias - why?? why not??
    self.new( text )
  end

  def initialize( text, opts={} )
    @template = ERB.new( text )
  end

  def render( binding )
    @template.result( binding )
  end

end # class ErbTemplate
end # module Pakman
