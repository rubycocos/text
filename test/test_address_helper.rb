# encoding: utf-8


require 'helper'

class TestAddressHelper < Minitest::Test

  def test_normalize_addr
    
    txt_io = [
      ['Alte Plauener Straße 24 // 95028 Hof', nil, 'Alte Plauener Straße 24 // 95028 Hof'],
      ['Alte Plauener Straße 24 // 95028 Hof', 'de', '95028 Hof // Alte Plauener Straße 24'],
      ['Mautner Markhof-Straße 11 // 2320 Schwechat', nil, 'Mautner Markhof-Straße 11 // 2320 Schwechat'],
      ['Mautner Markhof-Straße 11 // 2320 Schwechat', 'at', '2320 Schwechat // Mautner Markhof-Straße 11']
    ]

    txt_io.each_with_index do |txt,i|
      puts "testing [#{i}] #{txt[0]}"
      assert_equal txt[2], TextUtils.normalize_addr( txt[0], txt[1] )
    end

  end  # method test_normalize_addr


  def test_addr_without_postal_code  # aka generic rule

    txt_io = [
      ['London //',  'London'],
      ['// London',  'London'],
      ['// London  ',  'London'],
      ['  // London',  'London'],
      ['// London, W4 2QB', nil],
      ['// London | W4 2QB', nil],
      ['// London  W4 2QB', nil],
      ['Chiswick Lane South // London, W4 2QB', nil],
      ['The Griffin Brewery // Chiswick Lane South // London', nil], # three lines will NOT work, sorry
      ['// New York, NY', nil],
      ['// New York NY', nil]    # check: does it exist in the real world (e.g. w/o comma or pipe?) support it?
    ]

    txt_io.each_with_index do |txt,i|
      puts "testing [#{i}] #{txt[0]}"
      assert_equal txt[1], TextUtils.find_city_in_addr_without_postal_code( txt[0] )
    end
  end # method test_addr_without_postal_code


  def test_addr_with_postal_code

    txt_io = [
      ['2320 Schwechat // Mautner Markhof-Straße 11', 'at', 'Schwechat'],
      ['Mautner Markhof-Straße 11 // 2320 Schwechat', 'at', 'Schwechat'],
      ['3910 Zwettl // Syrnauer Straße 22-25', 'at', 'Zwettl'],
      ['Syrnauer Straße 22-25 // 3910 Zwettl', 'at', 'Zwettl'],
      ['2018 Antwerpen', 'be', 'Antwerpen'],
      ['2870 Breendonk-Puurs', 'be', 'Breendonk-Puurs'],
      ['Alte Plauener Straße 24 // 95028 Hof', 'de', 'Hof'],
      ['95028 Hof // Alte Plauener Straße 24', 'de', 'Hof'],
      ['284 15 Kutná Hora', 'cz', 'Kutná Hora'],
      ['288 25 Nymburk', 'cz', 'Nymburk'],
      ['036 42 Martin', 'sk', 'Martin'],
      ['974 05 Banská Bystrica', 'sk', 'Banská Bystrica'],
      ['Brooklyn | NY 11249', 'us', 'Brooklyn'],
      ['Brooklyn, NY 11249', 'us', 'Brooklyn'],
      ['Brooklyn | NY', 'us', 'Brooklyn'],
      ['Brooklyn, NY', 'us', 'Brooklyn'],
    ]

    txt_io.each_with_index do |txt,i|
      puts "testing [#{i}] #{txt[0]}"
      assert_equal txt[2], TextUtils.find_city_in_addr_with_postal_code( txt[0], txt[1] )
    end
  end # method test_addr_with_postal_code


  def test_addr

    txt_io = [
      ['London //', nil, 'London'],
      ['// London', nil, 'London'],
      ['// London  ', nil,  'London'],
      ['  // London', nil, 'London'],
      ['2320 Schwechat // Mautner Markhof-Straße 11', 'at', 'Schwechat'],
      ['Mautner Markhof-Straße 11 // 2320 Schwechat', 'at', 'Schwechat'],
      ['3910 Zwettl // Syrnauer Straße 22-25', 'at', 'Zwettl'],
      ['Syrnauer Straße 22-25 // 3910 Zwettl', 'at', 'Zwettl'],
      ['2018 Antwerpen', 'be', 'Antwerpen'],
      ['2870 Breendonk-Puurs', 'be', 'Breendonk-Puurs'],
      ['Alte Plauener Straße 24 // 95028 Hof', 'de', 'Hof'],
      ['95028 Hof // Alte Plauener Straße 24', 'de', 'Hof'],
      ['284 15 Kutná Hora', 'cz', 'Kutná Hora'],
      ['288 25 Nymburk', 'cz', 'Nymburk'],
      ['036 42 Martin', 'sk', 'Martin'],
      ['974 05 Banská Bystrica', 'sk', 'Banská Bystrica'],
      ['Brooklyn | NY 11249', 'us', 'Brooklyn'],
      ['Brooklyn, NY 11249', 'us', 'Brooklyn'],
      ['Brooklyn | NY', 'us', 'Brooklyn'],
      ['Brooklyn, NY', 'us', 'Brooklyn'],
    ]

    txt_io.each_with_index do |txt,i|
      puts "testing [#{i}] #{txt[0]}"
      assert_equal txt[2], TextUtils.find_city_in_addr( txt[0], txt[1] )
    end
  end # method test_addr


end # class TestAddressHelper