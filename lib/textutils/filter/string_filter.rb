# encoding: utf-8


module TextUtils
  module StringFilter

      ##  turn accented char into ascii look alike if possible
      ##
      ## todo: add some more
      ## see http://en.wikipedia.org/wiki/List_of_XML_and_HTML_character_entity_references  for more
      
      ## todo: add unicode codepoint name
      
      ##
      ## fix: do not auto-map to lover case??? why? why not??

    ASCIIFY_MAPPINGS = [
        ['ß', 'ss'],

        ['æ', 'ae'],
        ['ä', 'ae'],
        ['ā', 'a' ],  # e.g. Liepājas, Kāṭhmāḍaũ
        ['á', 'a' ],  # e.g. Bogotá, Králové
        ['à', 'a' ],  # e.g. Thành Phố Hồ Chí Minh [Saigon]
        ['ã', 'a' ],  # e.g  São Paulo
        ['ă', 'a' ],  # e.g. Chișinău
        ['â', 'a' ],  # e.g  Goiânia
        ['å', 'a' ],  # e.g. Vålerenga
        ['ą', 'a' ],  # e.g. Śląsk

        ['ç', 'c' ],  # e.g. São Gonçalo, Iguaçu, Neftçi
        ['ć', 'c' ],  # e.g. Budućnost
        ['č', 'c' ],  # e.g. Tradiční, Výčepní

        ['ḍ', 'd' ],  # e.g. Kāṭhmāḍaũ [Kathmandu]

        ['é', 'e' ],  # e.g. Vélez, Králové
        ['è', 'e' ],  # e.g. Rivières
        ['ê', 'e' ],  # e.g. Grêmio
        ['ě', 'e' ],  # e.g. Budějovice
        ['ĕ', 'e' ],  # e.g. Svĕtlý
        ['ė', 'e' ],  # e.g. Vėtra
        ['ë', 'e' ],  # e.g. Skënderbeu

        ['ğ', 'g' ],  # e.g. Qarabağ

        ['ḥ', 'h' ],  # e.g. Ad-Dawḥah [Doha]

        ['ì', 'i' ],  # e.g. Potosì
        ['í', 'i' ],  # e.g. Ústí
        ['ï', 'i' ],  # e.g. El Djazaïr
        ['ī', 'i' ],  # e.g. Al-Iskandarīyah [Alexandria]

        ['ł', 'l' ],  # e.g. Wisła, Wrocław
        ['ñ', 'n' ],  # e.g. Porteño
        ['ň', 'n' ],  # e.g. Plzeň, Třeboň

        ['ö', 'oe'],
        ['ő', 'o' ],  # e.g. Győri
        ['ó', 'o' ],  # e.g. Colón, Łódź, Kraków
        ['õ', 'o' ],  # e.g. Nõmme
        ['ô', 'o' ],  # e.g. Amazônia (pt)
        ['ō', 'o' ],  # e.g. Tōkyō, Pishōr
        ['ŏ', 'o' ],  # e.g. P'yŏngyang [Pyongyang]
        ['ø', 'o' ],  # e.g. Fuglafjørdur, København
        ['ố', 'o' ],  # e.g. Thành Phố Hồ Chí Minh [Saigon]
        ['ồ', 'o' ],  # e.g. Thành Phố Hồ Chí Minh [Saigon]
        ['ộ', 'o' ],  # e.g. Hà Nội [Hanoi]

        ['ř', 'r' ],  # e.g. Třeboň

        ['ș', 's' ],  # e.g. Chișinău, București
        ['ş', 's' ],  # e.g. Beşiktaş
        ['š', 's' ],  # e.g. Košice
        ['ṣ', 's' ], # e.g. Al-Mawṣil [Mosul]

        ['ť', 't' ],  # e.g. Měšťan
        ['ṭ', 't' ],  # e.g. Al-Kharṭūm [Khartoum], Kāṭhmāḍaũ

        ['ü', 'ue'],
        ['ú', 'u' ],  # e.g. Fútbol
        ['ù', 'u' ],  # e.g. Xyauyù (it)
        ['ū', 'u' ],  # e.g. Sūduva
        ['ů', 'u' ],  # e.g. Sládkův
        ['ũ', 'u' ],  # e.g. Kāṭhmāḍaũ [Kathmandu]

        ['ı', 'u' ],  # e.g. Bakı   # use u?? (Baku) why-why not?

        ['x̌', 'x'],   # e.g. Pex̌awar  [Peshawar]

        ['ý', 'y' ],  # e.g. Nefitrovaný
        ['ź', 'z' ],  # e.g. Łódź
        ['ž', 'z' ],  # e.g. Domžale, Petržalka
        ['ż', 'z' ],  # e.g. Lomża  (polish)

        ['Á', 'a' ],  # e.g. Águila (es)
        ['Č', 'c' ],  # e.g. České

        ['Ḥ', 'h' ],  # e.g. Ḥalab [Aleppo]
        ['Ḫ', 'h' ],  # e.g. Ḫamīs Mušayṭ
        ['İ', 'i' ],  # e.g. İnter
        ['Í', 'i' ],  # e.g. ÍBV
        ['Ł', 'l' ],  # e.g. Łódź

        ['Ö', 'oe' ], # e.g. Örebro
        ['Ō', 'o' ],  # e.g. Ōsaka [Osaka]
        ['Ø', 'o' ],  # e.g. Nogne Ø Imperial Stout (no)

        ['Ř', 'r' ],  # e.g. Řezák

        ['Ś', 's' ],  # e.g. Śląsk
        ['Š', 's' ],  # e.g. MŠK
        ['Ş', 's' ],  # e.g. Şüvälan
        ['Ṣ', 's' ],  # e.g. Ṣan'ā' [Sana'a]

        ['Ṭ', 't' ],  # e.g. Ṭarābulus [Tripoli]
        ['Ú', 'u' ],  # e.g. Ústí, Újpest
        ['Ž', 'z' ],   # e.g. Žilina
        ['Ż', 'z' ]    # e.g. Żywiec (polish)
      ]


  def asciify( content, options={} )
    ### fix: use content.each_char and hash_map or similar instead of gsub

    ASCIIFY_MAPPINGS.each do |mapping|
      content = content.gsub( mapping[0], mapping[1] )
    end
    content
  end

  def slugify( content, options={} )
    # 1) asciify
    content = asciify( content )

    # 2) replace space () with dash (-)
    content = content.gsub( ' ', '-' )
    content    
  end


  end # module StringFilter

  module Filter
    include StringFilter
  end # module Filter

end   # module TextUtils
