# encoding: utf-8


require 'helper'


class TestTaglist < Minitest::Test

  include TextUtils::ValueHelper   #  lets us use is_taglist?, etc.

  def test_taglist_starting_w_digit
    ## for now - taglist cannot start w/ number
    assert is_taglist?( '20 ha' ) == false
    assert is_taglist?( '5000 hl' ) == false
    assert is_taglist?( '5_000 hl' ) == false
  end

  def test_taglist_upcase
    ## taglist cannot use upcase letters
    assert is_taglist?( 'ABC' ) == false
  end

  def test_taglist
    assert is_taglist?( 'a' )
    assert is_taglist?( 'a|b|c' )
    assert is_taglist?( 'a b c' )
    assert is_taglist?( 'a_b_c' )
  end


end # class TestTaglist

