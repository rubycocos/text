# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_helper.rb
#  or better
#     rake test

require 'helper'

class TestValuesReader < Minitest::Test

  def test_header
    txt =<<EOS

Wieselburger Gold,      5.0%, 11.8°
____________________________________________
- Zwettler Brauerei|Privatbrauerei Zwettl

Zwettler Original,     5.1 %,  11.9°
Zwettler Export Lager, 5.0 %,  11.8°

______________________________________
- Brauerei Schwechat (Brau Union)

Schwechater,             5.0%, 11.5°, 41.0 kcal/100ml
Schwechater Zwickl,      5.4%, 12.5°, 45.0 kcal/100ml

EOS

    reader = ValuesReader.from_string( txt )

    i = 0
    reader.each_line do |attribs, values|
      i += 1

      puts "attribs:"
      pp attribs
      puts "values:"
      pp values

      if i == 1
        assert_equal attribs[:header],    nil
        assert_equal attribs[:key],      'wieselburgergold'
        assert_equal attribs[:title],    'Wieselburger Gold'
      elsif i == 2
        assert_equal attribs[:header],   'Zwettler Brauerei|Privatbrauerei Zwettl'
        assert_equal attribs[:key],      'zwettleroriginal'
        assert_equal attribs[:title],    'Zwettler Original'
      elsif i == 3
        assert_equal attribs[:header],   'Zwettler Brauerei|Privatbrauerei Zwettl'
        assert_equal attribs[:key],      'zwettlerexportlager'
        assert_equal attribs[:title],    'Zwettler Export Lager'
      elsif i == 4
        assert_equal attribs[:header],   'Brauerei Schwechat (Brau Union)'
        assert_equal attribs[:key],      'schwechater'
        assert_equal attribs[:title],    'Schwechater'
      elsif i == 5
        assert_equal attribs[:header],   'Brauerei Schwechat (Brau Union)'
        assert_equal attribs[:key],      'schwechaterzwickl'
        assert_equal attribs[:title],    'Schwechater Zwickl'
      else
        assert false   # should not get here
      end
    end

  end # test_header


  def test_escape_comma
    # note: double espace comma e.g. \\, becomes literal \,
    txt =<<EOS
[fuller]
  Fuller\\, Smith & Turner, 1845
  The Griffin Brewery // Chiswick Lane South // London, W4 2QB
  brands: Fuller's

fuller, Fuller\\, Smith & Turner, 1845, The Griffin Brewery // Chiswick Lane South // London\\, W4 2QB
EOS

    pp txt

    reader = ValuesReader.from_string( txt )

    i = 0
    reader.each_line do |attribs, values|
      i += 1

      puts "attribs:"
      pp attribs
      puts "values:"
      pp values

      if i == 1
        assert_equal attribs[:key],      'fuller'
        assert_equal attribs[:title],    'Fuller, Smith & Turner'
        assert_equal attribs[:grade],    nil
        assert_equal attribs[:synonyms], nil

        assert_equal values[0],  '1845'
        assert_equal values[1],  'The Griffin Brewery // Chiswick Lane South // London, W4 2QB'
        assert_equal values[2],  "brands: Fuller's"
      elsif i == 2
        assert_equal attribs[:key],      'fuller'
        assert_equal attribs[:title],    'Fuller, Smith & Turner'
        assert_equal attribs[:grade],    nil
        assert_equal attribs[:synonyms], nil

        assert_equal values[0],  '1845'
        assert_equal values[1],  'The Griffin Brewery // Chiswick Lane South // London, W4 2QB'
      else
        assert false   # should not get here
      end
    end
  end # test_escape_comma


  def test_mixed
    txt =<<EOS
##########
# Wien Umbgebung

[schwechat]
  Brauerei Schwechat (Brau Union) **, 1796
  www.schwechater.at
  2320 Schwechat // Mautner Markhof-Straße 11
  brands: Schwechater
  brau_union   # Part of Brau Union


#############
# Waldviertel

zwettler, Zwettler Brauerei|Privatbrauerei Zwettl **, 1709, www.zwettler.at, 3910 Zwettl // Syrnauer Straße 22-25
weitra, Weitra Bräu Bierwerkstatt|Brauerei Weitra *, 1321, www.bierwerkstatt.at, 3970 Weitra // Sparkasseplatz 160, zwettler   # Part of Zwettler

#############
# Weinviertel

[hubertus]
  Hubertus Bräu *, 1454
  www.hubertus.at
  2136 Laa/Thaya // Hubertusgasse 1
  brands: Hubertus

egger, Privatbrauerei Fritz Egger **, 1978, www.egger-bier.at, 3105 Unterradlberg // Tiroler Straße 18
EOS

    reader = ValuesReader.from_string( txt )

    i = 0
    reader.each_line do |attribs, values|
      i += 1

      puts "attribs:"
      pp attribs
      puts "values:"
      pp values

      if i == 1
        assert_equal attribs[:key],      'schwechat'
        assert_equal attribs[:title],    'Brauerei Schwechat (Brau Union)'
        assert_equal attribs[:grade],    2
        assert_equal attribs[:synonyms], nil

        assert_equal values[0],  '1796'
        assert_equal values[1],  'www.schwechater.at'
        assert_equal values[2],  '2320 Schwechat // Mautner Markhof-Straße 11'
        assert_equal values[3],  'brands: Schwechater'
        assert_equal values[-1], 'brau_union'
      elsif i == 2
        assert_equal attribs[:key],      'zwettler'
        assert_equal attribs[:title],    'Zwettler Brauerei'
        assert_equal attribs[:grade],    2
        assert_equal attribs[:synonyms], 'Privatbrauerei Zwettl'

        assert_equal values[0],  '1709'
        assert_equal values[1],  'www.zwettler.at'
        assert_equal values[2],  '3910 Zwettl // Syrnauer Straße 22-25'
      elsif i == 3
        assert_equal attribs[:key],      'weitra'
        assert_equal attribs[:title],    'Weitra Bräu Bierwerkstatt'
        assert_equal attribs[:grade],    3
        assert_equal attribs[:synonyms], 'Brauerei Weitra'

        assert_equal values[0],  '1321'
        assert_equal values[1],  'www.bierwerkstatt.at'
        assert_equal values[2],  '3970 Weitra // Sparkasseplatz 160'
        assert_equal values[-1], 'zwettler'
      elsif i == 4
        assert_equal attribs[:key],      'hubertus'
        assert_equal attribs[:title],    'Hubertus Bräu'
        assert_equal attribs[:grade],    3
        assert_equal attribs[:synonyms], nil

        assert_equal values[0],  '1454'
        assert_equal values[1],  'www.hubertus.at'
        assert_equal values[2],  '2136 Laa/Thaya // Hubertusgasse 1'
        assert_equal values[3],  'brands: Hubertus'
      elsif i == 5
        assert_equal attribs[:key],      'egger'
        assert_equal attribs[:title],    'Privatbrauerei Fritz Egger'
        assert_equal attribs[:grade],    2
        assert_equal attribs[:synonyms], nil

        assert_equal values[0],  '1978'
        assert_equal values[1],  'www.egger-bier.at'
        assert_equal values[2],  '3105 Unterradlberg // Tiroler Straße 18'
      else
        assert false   # should not get here
      end
    end
  end # test_mixed


  def test_multi_line_records
    txt =<<EOS
##########
# Wien Umbgebung

[schwechat]
  Brauerei Schwechat (Brau Union) **, 1796
  www.schwechater.at
  2320 Schwechat // Mautner Markhof-Straße 11
  brands: Schwechater
  brau_union   # Part of Brau Union


#############
# Waldviertel

[zwettler]
  Zwettler Brauerei|Privatbrauerei Zwettl **, 1709
  www.zwettler.at
  3910 Zwettl // Syrnauer Straße 22-25
  brands: Zwettler
EOS

    reader = ValuesReader.from_string( txt )

    i = 0
    reader.each_line do |attribs, values|
      i += 1

      puts "attribs:"
      pp attribs
      puts "values:"
      pp values

      if i == 1
        assert_equal attribs[:key],      'schwechat'
        assert_equal attribs[:title],    'Brauerei Schwechat (Brau Union)'
        assert_equal attribs[:grade],    2
        assert_equal attribs[:synonyms], nil

        assert_equal values[0],  '1796'
        assert_equal values[1],  'www.schwechater.at'
        assert_equal values[2],  '2320 Schwechat // Mautner Markhof-Straße 11'
        assert_equal values[3],  'brands: Schwechater'
        assert_equal values[-1], 'brau_union'
      elsif i == 2
        assert_equal attribs[:key],      'zwettler'
        assert_equal attribs[:title],    'Zwettler Brauerei'
        assert_equal attribs[:grade],    2
        assert_equal attribs[:synonyms], 'Privatbrauerei Zwettl'

        assert_equal values[0],  '1709'
        assert_equal values[1],  'www.zwettler.at'
        assert_equal values[2],  '3910 Zwettl // Syrnauer Straße 22-25'
        assert_equal values[3],  'brands: Zwettler'
      else
        assert false   # should not get here
      end
    end
  end  # test_multi_line_records


  def test_classic_csv_records

    txt =<<EOS
arsenal,     Arsenal|Arsenal FC|FC Arsenal,             ARS, city:london
manunited,   Manchester United|Man Utd|Manchester U.,   MUN, city:manchester
liverpool,   Liverpool|Liverpool FC|FC Liverpool,       LIV, city:liverpool
EOS

    reader = ValuesReader.from_string( txt )

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
        assert  false   # should not get here
      end
    end
  end  #  test_classic_csv_records


  def test_autogen_keys
    txt =<<EOS
Ottakringer Helles,                  5.2 %, 11.8°
Ottakringer Gold Fassl Spezial,      5.6 %, 12.7°
Ottakringer (Gold Fassl) Pils,       4.6 %, 11.2°
Ottakringer (Gold Fassl) Pur {Bio},  5.2 %, 11.8°, bio
EOS

    reader = ValuesReader.from_string( txt )

    i = 0
    reader.each_line do |attribs, values|
      i += 1

      puts "attribs:"
      pp attribs
      puts "values:"
      pp values

      if i == 1
        assert_equal attribs[:key],      'ottakringerhelles'
        assert_equal attribs[:title],    'Ottakringer Helles'
        assert_equal attribs[:synonyms], nil

        assert_equal values[0], '5.2 %'
        assert_equal values[1], '11.8°'
      elsif i == 2
        assert_equal attribs[:key],      'ottakringergoldfasslspezial'
        assert_equal attribs[:title],    'Ottakringer Gold Fassl Spezial'
        assert_equal attribs[:synonyms], nil

        assert_equal values[0], '5.6 %'
        assert_equal values[1], '12.7°'
      elsif i == 3
        assert_equal attribs[:key],      'ottakringerpils'
        assert_equal attribs[:title],    'Ottakringer (Gold Fassl) Pils'
        assert_equal attribs[:synonyms], nil

        assert_equal values[0], '4.6 %'
        assert_equal values[1], '11.2°'
      elsif i == 4
        assert_equal attribs[:key],      'ottakringerpur'
        assert_equal attribs[:title],    'Ottakringer (Gold Fassl) Pur {Bio}'
        assert_equal attribs[:synonyms], nil

        assert_equal values[0], '5.2 %'
        assert_equal values[1], '11.8°'
        assert_equal values[-1], 'bio'
      else
        assert false   # should not get here
      end
    end
  end # test_autogen_keys


end # class TestValuesReader
