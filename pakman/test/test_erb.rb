# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_erb.rb


require 'helper'


class TestErb < MiniTest::Test

class Ctx   # Context

  def initialize( hash )
    @hash = hash
    @headers = hash['headers']
    @slides  = hash['slides']
    
    puts 'hash:'
    pp @hash
    puts 'headers:'
    pp @headers
    puts 'slides:'
    pp @slides
  end

  attr_reader :headers
  attr_reader :slides

  def ctx
    ### todo: check if method_missing works with binding in erb???
    binding
  end
end

def test_merge
  hash = YAML.load_file( "#{Pakman.root}/test/data/test.yml" )
  ctx  = Ctx.new( hash )

  manifestsrc = "#{Pakman.root}/test/erb/pak/test.txt"
  outpath = "#{Pakman.root}/tmp/#{Time.now.to_i}"    ## pakpath/output path
  
  Pakman::Templater.new.merge_pak( manifestsrc, outpath, ctx.ctx, 'test' )
    
  assert true
end  # method test_merge

end # class TestErb

