# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'

class TestTitleHelper < MiniTest::Unit::TestCase

  def test_title_to_key
     
    txt_io = [
      [ 'São Paulo',   'saopaulo' ],
      [ 'São Gonçalo', 'saogoncalo' ],
      [ 'Výčepní',     'vycepni' ]
    ] 

    txt_io.each do |txt|
      assert_equal txt[1], TextUtils.title_to_key( txt[0] )
    end
  end


end # class TestTitleHelper