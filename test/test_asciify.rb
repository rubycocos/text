# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_asciify.rb


require 'helper'


class TestAsciify < Minitest::Test

  def test_asciify

    txt_io = [
      [ 'São Paulo',   'Sao Paulo' ],
      [ 'São Gonçalo', 'Sao Goncalo' ],
      [ 'Výčepní',     'Vycepni' ],
      [ 'Żubr', 'Zubr' ],
      [ 'Żywiec', 'Zywiec' ],
      [ 'Lomża Export', 'Lomza Export' ],
      [ 'Nogne Ø Imperial Stout', 'Nogne O Imperial Stout' ],
      [ 'Xyauyù', 'Xyauyu' ],
      [ 'Águila', 'Aguila' ],
      [ 'Arena Amazônia', 'Arena Amazonia' ],
      [ 'Tōkyō', 'Tokyo' ],
      [ 'Ōsaka', 'Osaka' ],
      [ 'El Djazaïr', 'El Djazair' ],
      [ 'Al-Kharṭūm', 'Al-Khartum' ],
      [ 'Ṭarābulus', 'Tarabulus' ],
      [ 'Al-Iskandarīyah', 'Al-Iskandariyah' ],
      [ 'Pishōr', 'Pishor' ],
      [ 'Pishāwar', 'Pishawar' ],
      [ 'Islām ābād', 'Islam abad' ],
      [ 'Thành Phố Hồ Chí Minh', 'Thanh Pho Ho Chi Minh' ],
      [ 'Åland Islands', 'Aland Islands' ],
      [ 'Bistrița', 'Bistrita' ],
      [ 'Piatra-Neamț', 'Piatra-Neamt' ],
      [ 'Constanța', 'Constanta' ],
      [ 'Galați', 'Galati' ],
      [ 'Reșița', 'Resita' ],
      [ 'Chișinău', 'Chisinau' ],
      [ "Pe\u{030C}awar", 'Pexawar'],  ## note: use unicode literal; Pex̌awar  -- see en.wikipedia.org/wiki/Peshawar
      [ 'Übelbach', 'Uebelbach' ]
    ]

    txt_io.each do |txt|
      assert_equal txt[1], TextUtils.asciify( txt[0] )
    end
  end # method test_asciify


end # class TestAsciify

