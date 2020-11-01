# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_liquid_drops.rb


require 'helper'


class TestLiquidDrops < MiniTest::Test

class HeadersDrop < Liquid::Drop

  def initialize( h )
    @h = h
  end

  def author()  puts "call author"; @h['author']; end
  def title()   puts "call title";  @h['title'];  end
end

class SlideDrop < Liquid::Drop

  def initialize( h )
    @h = h
  end

  def content()  puts "call content"; @h['content']; end
  def header()   puts "call header";  @h['header'];  end
end

def setup
  Liquid::Template.error_mode = :strict
end


def test_template
  hash = YAML.load_file( "#{Pakman.root}/test/data/test.yml" )
  headers = HeadersDrop.new( hash['headers'] )
  slides  = hash['slides'].map { |h| SlideDrop.new( h ) }
  ctx= { 'headers' => headers, 'slides' => slides }
  pp ctx
    
  path = "#{Pakman.root}/test/liquid/test.html"
  t = Pakman::LiquidTemplate.from_file( path )
  pp t.render( ctx )
    
  assert true
end

end # class TestLiquidDrops

