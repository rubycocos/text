# encoding: utf-8

###
# to run use
# ruby -I ./lib -I ./test test/test_title_finder.rb


require 'helper'


class TestTitleFinder < Minitest::Test

  include TextUtils::ValueHelper   #  lets us use find_grade, etc.


  def test_find_key_n_title
    attribs, _ = find_key_n_title( ['München [Munich]'] )  ## skip returned more_values (use _)
    assert_equal 'muenchen',  attribs[:key]
    assert_equal 'München',   attribs[:title]
    assert_equal '[Munich]',  attribs[:synonyms]
  end

  def test_find_key_n_title_w_tree
    attribs, _ = find_key_n_title( ['München [Munich] › Oberbayern › Bayern'] )  ## skip returned more_values (use _)
    assert_equal 'muenchen',  attribs[:key]
    assert_equal 'München',   attribs[:title]
    assert_equal '[Munich]',  attribs[:synonyms]
  end


  def test_title_tokenizer
    names = NameTokenizer.new.tokenize( 'München [Munich]' )
    assert_equal 2, names.size
    assert_equal 'München',  names[0]
    assert_equal '[Munich]', names[1]

    names = NameTokenizer.new.tokenize( 'FC Bayern Muenchen|Bayern Muenchen|Bayern' )
    assert_equal 3, names.size
    assert_equal 'FC Bayern Muenchen', names[0]
    assert_equal 'Bayern Muenchen',    names[1]
    assert_equal 'Bayern',             names[2]
  end

  def test_grade
    assert_equal [1,'Anton Bauer'], find_grade( '*** Anton Bauer' )
    assert_equal [2,'Anton Bauer'], find_grade( '** Anton Bauer' )
    assert_equal [3,'Anton Bauer'], find_grade( '* Anton Bauer' )
    assert_equal [4,'Anton Bauer'], find_grade( 'Anton Bauer' )

    assert_equal [1,'Anton Bauer'], find_grade( 'Anton Bauer ***' )
  end

end # class TestTitleFinder

