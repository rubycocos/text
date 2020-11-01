# encoding: utf-8


require 'helper'


class TestWikipedia < MiniTest::Unit::TestCase

  include LinktoHelper

  def test_search

    assert_equal "<a href='http://en.wikipedia.org/?search=ottakringer'>ottakringer</a>", wikipedia_search( 'ottakringer' )
    assert_equal "<a href='http://de.wikipedia.org/?search=ottakringer'>ottakringer</a>", wikipedia_de_search( 'ottakringer' )

  end

end # class TestWikipedia
