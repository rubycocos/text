# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_tree_reader.rb


require 'helper'

class TestTreeReader < MiniTest::Test

  def test_oberfranken
    reader = TreeReader.from_file( "#{TextUtils.root}/test/data/de-deutschland/3--by-bayern/4--oberfranken/orte.txt" )
 
    reader.each_line do |_|
      ## do nothing for now
    end
    
    assert true ## assume everything ok if we get here
  end

  def test_de
    reader = TreeReader.from_file( "#{TextUtils.root}/test/data/de-deutschland/orte.txt" )
 
    reader.each_line do |_|
      ## do nothing for now
    end

    assert true ## assume everything ok if we get here
  end

end # class TestTreeReader

