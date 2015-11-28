# encoding: utf-8


require 'helper'


class TestTitleMapper < Minitest::Test

  WineryStruct =  Struct.new(:key, :title, :synonyms)

  def test_title_table

    ### todo/fix: auto-add year and remove (1971) or (????) etc. from title!!!!

    titles_in = [
      WineryStruct.new( 'antonbauer',     'Anton Bauer (1971)' ),
      WineryStruct.new( 'josefbauer',      'Weingut Josef Bauer', 'Joe Bauer|Josef Bauer (????)' ),
      WineryStruct.new( 'bernhardott',     'Weingut Ott', 'Weingut Bernhard Ott|Bernhard Ott (1972)' ),
      WineryStruct.new( 'andreaspolsterer', 'Weingut Andreas B. Polsterer', 'Andreas B. Polsterer (1970)' )
    ]

    ## note: for regex the following must get escaped
    #   (  => \(
    #   )  => \)
    #   .  => \.
    #   ?  => \?

    titles_out2 = [
      ['antonbauer',       [ 'Anton Bauer \(1971\)', 'Anton Bauer']],
      ['josefbauer',       [ 'Weingut Josef Bauer', 'Josef Bauer \(\?\?\?\?\)', 'Josef Bauer', 'Joe Bauer' ]],
      ['bernhardott',      [ 'Weingut Bernhard Ott', 'Bernhard Ott \(1972\)', 'Bernhard Ott', 'Weingut Ott' ]],
      ['andreaspolsterer', [ 'Weingut Andreas B\. Polsterer', 'Andreas B\. Polsterer \(1970\)', 'Andreas B\. Polsterer' ]]
    ]

    mapper = TextUtils::TitleMapper.new( titles_in, 'winery' )
    titles_out = mapper.known_titles

    puts 'titles_out:'
    pp titles_out
    puts titles_out.to_s

    puts 'titles_out2:'
    pp titles_out2
    puts titles_out.to_s

    assert_equal titles_out2.to_s, titles_out.to_s

  end # method test_title_table


end # class TestTitleMapper
