# encoding: utf-8


require 'helper'


class TestTitleFinder < Minitest::Test

  include TextUtils::ValueHelper   #  lets us use find_grade, etc.

  def test_grade

    assert_equal [1,'Anton Bauer'], find_grade( '*** Anton Bauer' )
    assert_equal [2,'Anton Bauer'], find_grade( '** Anton Bauer' )
    assert_equal [3,'Anton Bauer'], find_grade( '* Anton Bauer' )
    assert_equal [4,'Anton Bauer'], find_grade( 'Anton Bauer' )

    assert_equal [1,'Anton Bauer'], find_grade( 'Anton Bauer ***' )

  end



end # class TestTitleFinder

