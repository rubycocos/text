# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'


class TestTitleHelper < MiniTest::Unit::TestCase

  def test_title_to_key
    
    puts '[debug] enter test_title_to_key()'

    txt_io = [
      [ 'São Paulo',   'saopaulo' ],
      [ 'São Gonçalo', 'saogoncalo' ],
      [ 'Výčepní',     'vycepni' ],
      [ 'Bock ‹Damm›', 'bockdamm' ],
      [ '‹Estrella› ‹Damm› Inedit', 'estrelladamminedit' ],
      [ '‹Hirter› Pils', 'hirterpils' ],
      [ '‹Villacher› Märzen', 'villachermaerzen' ],
      [ 'Bock <Damm>', 'bockdamm' ],
      [ '<Estrella> <Damm> Inedit', 'estrelladamminedit' ],
      [ 'Żubr', 'zubr' ],
      [ 'Żywiec', 'zywiec' ],
      [ 'Lomża Export', 'lomzaexport' ],
      [ 'Nogne Ø Imperial Stout', 'nogneoimperialstout' ],
      [ 'Xyauyù', 'xyauyu' ],
      [ 'Águila', 'aguila' ],
      [ '+Lupulus', 'lupulus' ],
      [ '+Malta', 'malta' ],
      [ 'Minerva 8:60', 'minerva860' ],
      [ 'Hop Crisis!', 'hopcrisis' ],
      [ '$Alianz$ Arena', 'alianzarena' ],
      [ 'Arena Amazônia', 'arenaamazonia' ],
      [ 'Tōkyō [Tokyo]', 'tokyo' ],
      [ 'El Djazaïr [Algiers]', 'eldjazair' ]
    ]

    txt_io.each do |txt|
      assert_equal txt[1], TextUtils.title_to_key( txt[0] )
    end

    puts '[debug] leave test_title_to_key()'

  end # method test_title_to_key


end # class TestTitleHelper