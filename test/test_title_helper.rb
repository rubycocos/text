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
      [ 'Ōsaka [Osaka]', 'osaka' ],
      [ 'El Djazaïr [Algiers]', 'eldjazair' ],
      [ 'Al-Kharṭūm [Khartoum]', 'alkhartum' ],
      [ 'Ṭarābulus [Tripoli]', 'tarabulus' ],
      [ 'Al-Iskandarīyah [Alexandria]', 'aliskandariyah' ],
      [ 'Pex̌awar', 'pexawar'],
      [ 'Pishōr', 'pishor' ],
      [ 'Pishāwar', 'pishawar' ],
      [ 'Islām ābād', 'islamabad' ],
      [ 'Thành Phố Hồ Chí Minh [Saigon]', 'thanhphohochiminh' ],
      [ 'Hà Nội [Hanoi]', 'hanoi' ],
      [ 'Donets’k', 'donetsk' ],
      [ 'Baghdād [Baghdad]', 'baghdad'],
      [ 'Al-Mawṣil [Mosul]', 'almawsil'],
      [ 'Al-Baṣrah [Basra]', 'albasrah'],
      [ 'Arbīl [Erbil]', 'arbil' ],
      [ 'Kirkūk [Kirkuk]', 'kirkuk' ],
      [ 'Tehrān [Tehran]', 'tehran' ],
      [ 'Eṣfahān [Isfahan]', 'esfahan' ],
      [ 'Shīrāz [Shiraz]', 'shiraz' ],
      [ 'Tabrīz [Tabriz]', 'tabriz' ],
      [ 'Ahvāz [Ahvaz]', 'ahvaz' ],
      [ 'Ad-Dawḥah [Doha]', 'addawhah'],
      [ 'Ḥalab [Aleppo]', 'halab'],
      [ 'Al-Madīnah [Medina]', 'almadinah'],
      [ 'Ad-Dammām [Dammam]', 'addammam' ],
      [ 'Aṭ-Ṭā’if', 'attaif'], 
      [ 'Ḫamīs Mušayṭ', 'hamismusayt'],
      [ "Ṣan'ā' [Sana'a]", 'sana'],
      [ "P'yŏngyang [Pyongyang]", 'pyongyang' ],
      [ 'Kāṭhmāḍaũ [Kathmandu]', 'kathmadau' ]
    ]

    txt_io.each do |txt|
      assert_equal txt[1], TextUtils.title_to_key( txt[0] )
    end

    puts '[debug] leave test_title_to_key()'

  end # method test_title_to_key


end # class TestTitleHelper