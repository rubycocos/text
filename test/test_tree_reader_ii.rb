# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_tree_reader_ii.rb


require 'helper'

class TestTreeReaderIi < MiniTest::Test

  def test_at_n
    reader = TreeReader.from_file( "#{TextUtils.root}/test/data/at-austria/1--n-niederoesterreich/orte.txt" )
 
    reader.check
 
    assert true ## assume everything ok if we get here
  end

end # class TestTreeReaderIi
