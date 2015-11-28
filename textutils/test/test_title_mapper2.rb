# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_title_mapper2.rb


require 'helper'


class TestTitleMapper2 < Minitest::Test

  ClubStruct =  Struct.new(:key, :title, :synonyms)

  def test_title_table

    titles_in = [
      ClubStruct.new( 'barcelona',  'Barcelona', 'FC Barcelona' ),
      ClubStruct.new( 'espanyol',   'Espanyol',  'RCD Espanyol|Espanyol Barcelona' ),
      ClubStruct.new( 'sevilla',    'Sevilla',   'Sevilla FC' )
    ]

    mapper = TextUtils::TitleMapper2.new( titles_in, 'club' )
    titles_out = mapper.known_titles

    puts 'titles_out:'
    pp titles_out

    line = "Espanyol Barcelona  1-0  FC Barcelona"
    mapper.map_titles!( line )
    puts "=> #{line}"

    club1 = mapper.find_key!( line )
    club2 = mapper.find_key!( line )
    puts "=> #{line}"

    assert_equal 'espanyol',  club1
    assert_equal 'barcelona', club2

    assert true   ## assume everything ok if we get here

  end # method test_title_table


end # class TestTitleMapper2
