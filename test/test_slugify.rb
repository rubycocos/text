# encoding: utf-8

require 'helper'

class TestSlugify < MiniTest::Unit::TestCase

  def test_slugify

    txt_io = [
      [ 'São Paulo',   'sao-paulo' ],
      [ 'São Gonçalo', 'sao-goncalo' ],
      [ 'Výčepní',     'vycepni' ],
      [ 'Żubr', 'zubr' ],
      [ 'Żywiec', 'zywiec' ],
      [ 'Lomża Export', 'lomza-export' ],
      [ 'Nogne Ø Imperial Stout', 'nogne-o-imperial-stout' ],
      [ 'Xyauyù', 'xyauyu' ],
      [ 'Águila', 'aguila' ],
      [ 'Arena Amazônia', 'arena-amazonia' ],
      [ 'Tōkyō', 'tokyo' ],
      [ 'Ōsaka', 'osaka' ],
      [ 'El Djazaïr', 'el-djazair' ],
      [ 'Al-Kharṭūm', 'al-khartum' ],
      [ 'Ṭarābulus', 'tarabulus' ],
      [ 'Al-Iskandarīyah', 'al-iskandariyah' ],
      [ 'Pex̌awar', 'pexawar'],
      [ 'Pishōr', 'pishor' ],
      [ 'Pishāwar', 'pishawar' ],
      [ 'Islām ābād', 'islam-abad' ],
      [ 'Thành Phố Hồ Chí Minh', 'thanh-pho-ho-chi-minh' ],
      [ 'Åland Islands', 'aland-islands' ]
    ]

    txt_io.each do |txt|
      assert_equal txt[1], TextUtils.slugify( txt[0] )
    end
  end # method test_slugify


end # class TestSlugify
