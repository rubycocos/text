# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_liquid.rb


require 'helper'


class TestLiquid < MiniTest::Test


def setup
  Liquid::Template.error_mode = :strict
end


def test_template
  hash = YAML.load_file( "#{Pakman.root}/test/data/test.yml" )
  ctx= { 'headers' => hash['headers'], 'slides' => hash['slides'] }
  pp ctx
    
  path = "#{Pakman.root}/test/liquid/test.html"
  t = Pakman::LiquidTemplate.from_file( path )
  pp t.render( ctx )
    
  assert true
end

def test_page_template
  hash = YAML.load_file( "#{Pakman.root}/test/data/test.yml" )
  ctx= { 'headers' => hash['headers'], 'slides' => hash['slides'] }
  pp ctx
    
  path = "#{Pakman.root}/test/liquid/pak/test.html"
  t = Pakman::LiquidPageTemplate.from_file( path )
  pp t.render( ctx )
    
  assert true
end

def test_merge
  hash = YAML.load_file( "#{Pakman.root}/test/data/test.yml" )
  ctx= { 'headers' => hash['headers'], 'slides' => hash['slides'] }
  pp ctx

  manifestsrc = "#{Pakman.root}/test/liquid/pak/test.txt"
  outpath = "#{Pakman.root}/tmp/#{Time.now.to_i}"    ## pakpath/output path
  
  Pakman::LiquidTemplater.new.merge_pak( manifestsrc, outpath, ctx, 'test' )

  assert true
end  # method test_merge

end # class TestLiquid

