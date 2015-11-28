# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'

class TestUnicodeHelper < Minitest::Test

  def test_convert_unicode_dashes
    
    txt_in  = "\u2010 \u2011 \u2212 \u2013 \u2014"  # NB: unicode chars require double quoted strings
    txt_out = '- - - - -'

    assert_equal txt_out, TextUtils.convert_unicode_dashes_to_plain_ascii( txt_in )
  end

end # class TestUnicodeHelper