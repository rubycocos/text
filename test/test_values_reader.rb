# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'

class TestValuesReader < MiniTest::Unit::TestCase

  def test_classic_csv_records

    txt =<<EOS
arsenal,     Arsenal|Arsenal FC|FC Arsenal,             ARS, city:london
manunited,   Manchester United|Man Utd|Manchester U.,   MUN, city:manchester
liverpool,   Liverpool|Liverpool FC|FC Liverpool,       LIV, city:liverpool
EOS

    reader = ValuesReader.new( txt )

    i = 0
    reader.each_line do |attribs, values|
      i += 1

      puts "attribs:"
      pp attribs
      puts "values:"
      pp values

      if i == 1
        assert_equal attribs[:key],      'arsenal'
        assert_equal attribs[:title],    'Arsenal'
        assert_equal attribs[:synonyms], 'Arsenal FC|FC Arsenal'

        assert_equal values[0], 'ARS'
        assert_equal values[1], 'city:london'
      elsif i == 2
      elsif i == 3
      else
        assert_equal true, false   # should not get here
      end

    end

=begin
    txt_io = [
      [ 'São Paulo',   'saopaulo' ],
      [ 'São Gonçalo', 'saogoncalo' ],
      [ 'Výčepní',     'vycepni' ]
    ] 

    txt_io.each do |txt|
      assert_equal txt[1], TextUtils.title_to_key( txt[0] )
    end
=end
  end


end # class TestValuesReader
