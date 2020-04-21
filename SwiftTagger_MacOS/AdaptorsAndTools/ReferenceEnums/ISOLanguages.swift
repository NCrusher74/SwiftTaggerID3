//
//  ISOLanguages.swift
//  SwiftTagger_MacOS
//
//  Created by Nolaine Crusher on 4/14/20.
//  Copyright © 2020 Nolaine Crusher. All rights reserved.
//

public enum ISO6392Codes: String, CaseIterable {
    
    public init?(nativeName: String) {
        self = ISO6392Codes.nativeNameToIsoCode[nativeName] ?? .und
    }
    
    /// Afar
    case aar = "Afar"
    /// Abkhazian
    case abk = "Abkhazian"
    /// Achinese
    case ace = "Achinese"
    /// Acoli
    case ach = "Acoli"
    /// Adangme
    case ada = "Adangme"
    /// Adyghe; Adygei
    case ady = "Adyghe; Adygei"
    /// Afro-Asiatic languages
    case afa = "Afro-Asiatic languages"
    /// Afrihili
    case afh = "Afrihili"
    /// Afrikaans
    case afr = "Afrikaans"
    /// Ainu
    case ain = "Ainu"
    /// Akan
    case aka = "Akan"
    /// Akkadian
    case akk = "Akkadian"
    /// Albanian
    case sqi = "Albanian"
    /// Aleut
    case ale = "Aleut"
    /// Algonquian languages
    case alg = "Algonquian languages"
    /// Southern Altai
    case alt = "Southern Altai"
    /// Amharic
    case amh = "Amharic"
    /// English, Old (ca.450–1100)
    case ang = "English, Old (ca.450–1100)"
    /// Angika
    case anp = "Angika"
    /// Apache languages
    case apa = "Apache languages"
    /// Arabic
    case ara = "Arabic"
    /// Official Aramaic, (700–300 BCE); Imperial Aramaic, (700–300 BCE)
    case arc = "Official Aramaic, (700–300 BCE); Imperial Aramaic, (700–300 BCE)"
    /// Aragonese
    case arg = "Aragonese"
    /// Armenian
    case hye = "Armenian"
    /// Mapudungun; Mapuche
    case arn = "Mapudungun; Mapuche"
    /// Arapaho
    case arp = "Arapaho"
    /// Artificial languages
    case art = "Artificial languages"
    /// Arawak
    case arw = "Arawak"
    /// Assamese
    case asm = "Assamese"
    /// Asturian; Bable; Leonese; Asturleonese
    case ast = "Asturian; Bable; Leonese; Asturleonese"
    /// Athapascan languages
    case ath = "Athapascan languages"
    /// Australian languages
    case aus = "Australian languages"
    /// Avaric
    case ava = "Avaric"
    /// Avestan
    case ave = "Avestan"
    /// Awadhi
    case awa = "Awadhi"
    /// Aymara
    case aym = "Aymara"
    /// Azerbaijani
    case aze = "Azerbaijani"
    /// Banda languages
    case bad = "Banda languages"
    /// Bamileke languages
    case bai = "Bamileke languages"
    /// Bashkir
    case bak = "Bashkir"
    /// Baluchi
    case bal = "Baluchi"
    /// Bambara
    case bam = "Bambara"
    /// Balinese
    case ban = "Balinese"
    /// Basque
    case eus = "Basque"
    /// Basa
    case bas = "Basa"
    /// Baltic languages
    case bat = "Baltic languages"
    /// Beja; Bedawiyet
    case bej = "Beja; Bedawiyet"
    /// Belarusian
    case bel = "Belarusian"
    /// Bemba
    case bem = "Bemba"
    /// Bengali
    case ben = "Bengali"
    /// Berber languages
    case ber = "Berber languages"
    /// Bhojpuri
    case bho = "Bhojpuri"
    /// Bihari languages
    case bih = "Bihari languages"
    /// Bikol
    case bik = "Bikol"
    /// Bini; Edo
    case bin = "Bini; Edo"
    /// Bislama
    case bis = "Bislama"
    /// Siksika
    case bla = "Siksika"
    /// Bantu (Other)
    case bnt = "Bantu (Other)"
    /// Tibetan
    case bod = "Tibetan"
    /// Bosnian
    case bos = "Bosnian"
    /// Braj
    case bra = "Braj"
    /// Breton
    case bre = "Breton"
    /// Batak languages
    case btk = "Batak languages"
    /// Buriat
    case bua = "Buriat"
    /// Buginese
    case bug = "Buginese"
    /// Bulgarian
    case bul = "Bulgarian"
    /// Burmese
    case mya = "Burmese"
    /// Blin; Bilin
    case byn = "Blin; Bilin"
    /// Caddo
    case cad = "Caddo"
    /// Central American Indian languages
    case cai = "Central American Indian languages"
    /// Galibi Carib
    case car = "Galibi Carib"
    /// Catalan; Valencian
    case cat = "Catalan; Valencian"
    /// Caucasian languages
    case cau = "Caucasian languages"
    /// Cebuano
    case ceb = "Cebuano"
    /// Celtic languages
    case cel = "Celtic languages"
    /// Czech
    case ces = "Czech"
    /// Chamorro
    case cha = "Chamorro"
    /// Chibcha
    case chb = "Chibcha"
    /// Chechen
    case che = "Chechen"
    /// Chagatai
    case chg = "Chagatai"
    /// Chinese
    case zho = "Chinese"
    /// Chuukese
    case chk = "Chuukese"
    /// Mari
    case chm = "Mari"
    /// Chinook jargon
    case chn = "Chinook jargon"
    /// Choctaw
    case cho = "Choctaw"
    /// Chipewyan; Dene Suline
    case chp = "Chipewyan; Dene Suline"
    /// Cherokee
    case chr = "Cherokee"
    /// Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic
    case chu = "Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic"
    /// Chuvash
    case chv = "Chuvash"
    /// Cheyenne
    case chy = "Cheyenne"
    /// Chamic languages
    case cmc = "Chamic languages"
    /// Montenegrin
    case cnr = "Montenegrin"
    /// Coptic
    case cop = "Coptic"
    /// Cornish
    case cor = "Cornish"
    /// Corsican
    case cos = "Corsican"
    /// Creoles and pidgins, English based
    case cpe = "Creoles and pidgins, English based"
    /// Creoles and pidgins, French-based
    case cpf = "Creoles and pidgins, French-based"
    /// Creoles and pidgins, Portuguese-based
    case cpp = "Creoles and pidgins, Portuguese-based"
    /// Cree
    case cre = "Cree"
    /// Crimean Tatar; Crimean Turkish
    case crh = "Crimean Tatar; Crimean Turkish"
    /// Creoles and pidgins
    case crp = "Creoles and pidgins"
    /// Kashubian
    case csb = "Kashubian"
    /// Cushitic languages
    case cus = "Cushitic languages"
    /// Welsh
    case cym = "Welsh"
    /// Dakota
    case dak = "Dakota"
    /// Danish
    case dan = "Danish"
    /// Dargwa
    case dar = "Dargwa"
    /// Land Dayak languages
    case day = "Land Dayak languages"
    /// Delaware
    case del = "Delaware"
    /// Slave (isoName: Athapascan)
    case den = "Slave (isoName: Athapascan)"
    /// German
    case deu = "German"
    /// Dogrib
    case dgr = "Dogrib"
    /// Dinka
    case din = "Dinka"
    /// Divehi; Dhivehi; Maldivian
    case div = "Divehi; Dhivehi; Maldivian"
    /// Dogri
    case doi = "Dogri"
    /// Dravidian languages
    case dra = "Dravidian languages"
    /// Lower Sorbian
    case dsb = "Lower Sorbian"
    /// Duala
    case dua = "Duala"
    /// Dutch, Middle (ca. 1050–1350)
    case dum = "Dutch, Middle (ca. 1050–1350)"
    /// Dutch; Flemish
    case nld = "Dutch; Flemish"
    /// Dyula
    case dyu = "Dyula"
    /// Dzongkha
    case dzo = "Dzongkha"
    /// Efik
    case efi = "Efik"
    /// Egyptian (Ancient)
    case egy = "Egyptian (Ancient)"
    /// Ekajuk
    case eka = "Ekajuk"
    /// Greek, Modern (1453–)
    case ell = "Greek, Modern (1453–)"
    /// Elamite
    case elx = "Elamite"
    /// English
    case eng = "English"
    /// English, Middle (1100–1500)
    case enm = "English, Middle (1100–1500)"
    /// Esperanto
    case epo = "Esperanto"
    /// Estonian
    case est = "Estonian"
    /// Ewe
    case ewe = "Ewe"
    /// Ewondo
    case ewo = "Ewondo"
    /// Fang
    case fan = "Fang"
    /// Faroese
    case fao = "Faroese"
    /// Persian
    case fas = "Persian"
    /// Fanti
    case fat = "Fanti"
    /// Fijian
    case fij = "Fijian"
    /// Filipino; Pilipino
    case fil = "Filipino; Pilipino"
    /// Finnish
    case fin = "Finnish"
    /// Finno-Ugrian languages
    case fiu = "Finno-Ugrian languages"
    /// Fon
    case fon = "Fon"
    /// French
    case fra = "French"
    /// French, Middle (ca. 1400–1600)
    case frm = "French, Middle (ca. 1400–1600)"
    /// French, Old (842–ca. 1400)
    case fro = "French, Old (842–ca. 1400)"
    /// Northern Frisian
    case frr = "Northern Frisian"
    /// Eastern Frisian
    case frs = "Eastern Frisian"
    /// Western Frisian
    case fry = "Western Frisian"
    /// Fulah
    case ful = "Fulah"
    /// Friulian
    case fur = "Friulian"
    /// Ga
    case gaa = "Ga"
    /// Gayo
    case gay = "Gayo"
    /// Gbaya
    case gba = "Gbaya"
    /// Germanic languages
    case gem = "Germanic languages"
    /// Georgian
    case kat = "Georgian"
    /// Geez
    case gez = "Geez"
    /// Gilbertese
    case gil = "Gilbertese"
    /// Gaelic; Scottish Gaelic
    case gla = "Gaelic; Scottish Gaelic"
    /// Irish
    case gle = "Irish"
    /// Galician
    case glg = "Galician"
    /// Manx
    case glv = "Manx"
    /// German, Middle High (ca. 1050–1500)
    case gmh = "German, Middle High (ca. 1050–1500)"
    /// German, Old High (ca. 750–1050)
    case goh = "German, Old High (ca. 750–1050)"
    /// Gondi
    case gon = "Gondi"
    /// Gorontalo
    case gor = "Gorontalo"
    /// Gothic
    case got = "Gothic"
    /// Grebo
    case grb = "Grebo"
    /// Greek, Ancient (to 1453)
    case grc = "Greek, Ancient (to 1453)"
    /// Guarani
    case grn = "Guarani"
    /// Swiss German; Alemannic; Alsatian
    case gsw = "Swiss German; Alemannic; Alsatian"
    /// Gujarati
    case guj = "Gujarati"
    /// Gwich'in
    case gwi = "Gwich'in"
    /// Haida
    case hai = "Haida"
    /// Haitian; Haitian Creole
    case hat = "Haitian; Haitian Creole"
    /// Hausa
    case hau = "Hausa"
    /// Hawaiian
    case haw = "Hawaiian"
    /// Hebrew
    case heb = "Hebrew"
    /// Herero
    case her = "Herero"
    /// Hiligaynon
    case hil = "Hiligaynon"
    /// Himachali languages; Pahari languages
    case him = "Himachali languages; Pahari languages"
    /// Hindi
    case hin = "Hindi"
    /// Hittite
    case hit = "Hittite"
    /// Hmong; Mong
    case hmn = "Hmong; Mong"
    /// Hiri Motu
    case hmo = "Hiri Motu"
    /// Croatian
    case hrv = "Croatian"
    /// Upper Sorbian
    case hsb = "Upper Sorbian"
    /// Hungarian
    case hun = "Hungarian"
    /// Hupa
    case hup = "Hupa"
    /// Iban
    case iba = "Iban"
    /// Igbo
    case ibo = "Igbo"
    /// Icelandic
    case isl = "Icelandic"
    /// Ido
    case ido = "Ido"
    /// Sichuan Yi; Nuosu
    case iii = "Sichuan Yi; Nuosu"
    /// Ijo languages
    case ijo = "Ijo languages"
    /// Inuktitut
    case iku = "Inuktitut"
    /// Interlingue; Occidental
    case ile = "Interlingue; Occidental"
    /// Iloko
    case ilo = "Iloko"
    /// Interlingua (International Auxiliary Language Association)
    case ina = "Interlingua (International Auxiliary Language Association)"
    /// Indic languages
    case inc = "Indic languages"
    /// Indonesian
    case ind = "Indonesian"
    /// Indo-European languages
    case ine = "Indo-European languages"
    /// Ingush
    case inh = "Ingush"
    /// Inupiaq
    case ipk = "Inupiaq"
    /// Iranian languages
    case ira = "Iranian languages"
    /// Iroquoian languages
    case iro = "Iroquoian languages"
    /// Italian
    case ita = "Italian"
    /// Javanese
    case jav = "Javanese"
    /// Lojban
    case jbo = "Lojban"
    /// Japanese
    case jpn = "Japanese"
    /// Judeo-Persian
    case jpr = "Judeo-Persian"
    /// Judeo-Arabic
    case jrb = "Judeo-Arabic"
    /// Kara-Kalpak
    case kaa = "Kara-Kalpak"
    /// Kabyle
    case kab = "Kabyle"
    /// Kachin; Jingpho
    case kac = "Kachin; Jingpho"
    /// Kalaallisut; Greenlandic
    case kal = "Kalaallisut; Greenlandic"
    /// Kamba
    case kam = "Kamba"
    /// Kannada
    case kan = "Kannada"
    /// Karen languages
    case kar = "Karen languages"
    /// Kashmiri
    case kas = "Kashmiri"
    /// Kanuri
    case kau = "Kanuri"
    /// Kawi
    case kaw = "Kawi"
    /// Kazakh
    case kaz = "Kazakh"
    /// Kabardian
    case kbd = "Kabardian"
    /// Khasi
    case kha = "Khasi"
    /// Khoisan languages
    case khi = "Khoisan languages"
    /// Central Khmer
    case khm = "Central Khmer"
    /// Khotanese; Sakan
    case kho = "Khotanese; Sakan"
    /// Kikuyu; Gikuyu
    case kik = "Kikuyu; Gikuyu"
    /// Kinyarwanda
    case kin = "Kinyarwanda"
    /// Kirghiz; Kyrgyz
    case kir = "Kirghiz; Kyrgyz"
    /// Kimbundu
    case kmb = "Kimbundu"
    /// Konkani
    case kok = "Konkani"
    /// Komi
    case kom = "Komi"
    /// Kongo
    case kon = "Kongo"
    /// Korean
    case kor = "Korean"
    /// Kosraean
    case kos = "Kosraean"
    /// Kpelle
    case kpe = "Kpelle"
    /// Karachay-Balkar
    case krc = "Karachay-Balkar"
    /// Karelian
    case krl = "Karelian"
    /// Kru languages
    case kro = "Kru languages"
    /// Kurukh
    case kru = "Kurukh"
    /// Kuanyama; Kwanyama
    case kua = "Kuanyama; Kwanyama"
    /// Kumyk
    case kum = "Kumyk"
    /// Kurdish
    case kur = "Kurdish"
    /// Kutenai
    case kut = "Kutenai"
    /// Ladino
    case lad = "Ladino"
    /// Lahnda
    case lah = "Lahnda"
    /// Lamba
    case lam = "Lamba"
    /// Lao
    case lao = "Lao"
    /// Latin
    case lat = "Latin"
    /// Latvian
    case lav = "Latvian"
    /// Lezghian
    case lez = "Lezghian"
    /// Limburgan; Limburger; Limburgish
    case lim = "Limburgan; Limburger; Limburgish"
    /// Lingala
    case lin = "Lingala"
    /// Lithuanian
    case lit = "Lithuanian"
    /// Mongo
    case lol = "Mongo"
    /// Lozi
    case loz = "Lozi"
    /// Luxembourgish; Letzeburgesch
    case ltz = "Luxembourgish; Letzeburgesch"
    /// Luba-Lulua
    case lua = "Luba-Lulua"
    /// Luba-Katanga
    case lub = "Luba-Katanga"
    /// Ganda
    case lug = "Ganda"
    /// Luiseno
    case lui = "Luiseno"
    /// Lunda
    case lun = "Lunda"
    /// Luo (Kenya and Tanzania)
    case luo = "Luo (Kenya and Tanzania)"
    /// Lushai
    case lus = "Lushai"
    /// Macedonian
    case mkd = "Macedonian"
    /// Madurese
    case mad = "Madurese"
    /// Magahi
    case mag = "Magahi"
    /// Marshallese
    case mah = "Marshallese"
    /// Maithili
    case mai = "Maithili"
    /// Makasar
    case mak = "Makasar"
    /// Malayalam
    case mal = "Malayalam"
    /// Mandingo
    case man = "Mandingo"
    /// Maori
    case mri = "Maori"
    /// Austronesian languages
    case map = "Austronesian languages"
    /// Marathi
    case mar = "Marathi"
    /// Masai
    case mas = "Masai"
    /// Malay
    case msa = "Malay"
    /// Moksha
    case mdf = "Moksha"
    /// Mandar
    case mdr = "Mandar"
    /// Mende
    case men = "Mende"
    /// Irish, Middle (900–1200)
    case mga = "Irish, Middle (900–1200)"
    /// Mi'kmaq; Micmac
    case mic = "Mi'kmaq; Micmac"
    /// Minangkabau
    case min = "Minangkabau"
    /// Uncoded languages
    case mis = "Uncoded languages"
    /// Mon-Khmer languages
    case mkh = "Mon-Khmer languages"
    /// Malagasy
    case mlg = "Malagasy"
    /// Maltese
    case mlt = "Maltese"
    /// Manchu
    case mnc = "Manchu"
    /// Manipuri
    case mni = "Manipuri"
    /// Manobo languages
    case mno = "Manobo languages"
    /// Mohawk
    case moh = "Mohawk"
    /// Mongolian
    case mon = "Mongolian"
    /// Mossi
    case mos = "Mossi"
    /// Multiple languages
    case mul = "Multiple languages"
    /// Munda languages
    case mun = "Munda languages"
    /// Creek
    case mus = "Creek"
    /// Mirandese
    case mwl = "Mirandese"
    /// Marwari
    case mwr = "Marwari"
    /// Mayan languages
    case myn = "Mayan languages"
    /// Erzya
    case myv = "Erzya"
    /// Nahuatl languages
    case nah = "Nahuatl languages"
    /// North American Indian languages
    case nai = "North American Indian languages"
    /// Neapolitan
    case nap = "Neapolitan"
    /// Nauru
    case nau = "Nauru"
    /// Navajo; Navaho
    case nav = "Navajo; Navaho"
    /// Ndebele, South; South Ndebele
    case nbl = "Ndebele, South; South Ndebele"
    /// Ndebele, North; North Ndebele
    case nde = "Ndebele, North; North Ndebele"
    /// Ndonga
    case ndo = "Ndonga"
    /// Low German; Low Saxon; German, Low; Saxon, Low
    case nds = "Low German; Low Saxon; German, Low; Saxon, Low"
    /// Nepali
    case nep = "Nepali"
    /// Nepal Bhasa; Newari
    case new = "Nepal Bhasa; Newari"
    /// Nias
    case nia = "Nias"
    /// Niger-Kordofanian languages
    case nic = "Niger-Kordofanian languages"
    /// Niuean
    case niu = "Niuean"
    /// Norwegian Nynorsk; Nynorsk, Norwegian
    case nno = "Norwegian Nynorsk; Nynorsk, Norwegian"
    /// Bokmål, Norwegian; Norwegian Bokmål
    case nob = "Bokmål, Norwegian; Norwegian Bokmål"
    /// Nogai
    case nog = "Nogai"
    /// Norse, Old
    case non = "Norse, Old"
    /// Norwegian
    case nor = "Norwegian"
    /// N'Ko
    case nqo = "N'Ko"
    /// Pedi; Sepedi; Northern Sotho
    case nso = "Pedi; Sepedi; Northern Sotho"
    /// Nubian languages
    case nub = "Nubian languages"
    /// Classical Newari; Old Newari; Classical Nepal Bhasa
    case nwc = "Classical Newari; Old Newari; Classical Nepal Bhasa"
    /// Chichewa; Chewa; Nyanja
    case nya = "Chichewa; Chewa; Nyanja"
    /// Nyamwezi
    case nym = "Nyamwezi"
    /// Nyankole
    case nyn = "Nyankole"
    /// Nyoro
    case nyo = "Nyoro"
    /// Nzima
    case nzi = "Nzima"
    /// Occitan (post 1500); Provençal
    case oci = "Occitan (post 1500); Provençal"
    /// Ojibwa
    case oji = "Ojibwa"
    /// Oriya
    case ori = "Oriya"
    /// Oromo
    case orm = "Oromo"
    /// Osage
    case osa = "Osage"
    /// Ossetian; Ossetic
    case oss = "Ossetian; Ossetic"
    /// Turkish, Ottoman (1500–1928)
    case ota = "Turkish, Ottoman (1500–1928)"
    /// Otomian languages
    case oto = "Otomian languages"
    /// Papuan languages
    case paa = "Papuan languages"
    /// Pangasinan
    case pag = "Pangasinan"
    /// Pahlavi
    case pal = "Pahlavi"
    /// Pampanga; Kapampangan
    case pam = "Pampanga; Kapampangan"
    /// Panjabi; Punjabi
    case pan = "Panjabi; Punjabi"
    /// Papiamento
    case pap = "Papiamento"
    /// Palauan
    case pau = "Palauan"
    /// Persian, Old (ca. 600–400 B.C.)
    case peo = "Persian, Old (ca. 600–400 B.C.)"
    /// Philippine languages
    case phi = "Philippine languages"
    /// Phoenician
    case phn = "Phoenician"
    /// Pali
    case pli = "Pali"
    /// Polish
    case pol = "Polish"
    /// Pohnpeian
    case pon = "Pohnpeian"
    /// Portuguese
    case por = "Portuguese"
    /// Prakrit languages
    case pra = "Prakrit languages"
    /// Provençal, Old (to 1500); Old Occitan (to 1500)
    case pro = "Provençal, Old (to 1500); Old Occitan (to 1500)"
    /// Pushto; Pashto
    case pus = "Pushto; Pashto"
    /// Quechua
    case que = "Quechua"
    /// Rajasthani
    case raj = "Rajasthani"
    /// Rapanui
    case rap = "Rapanui"
    /// Rarotongan; Cook Islands Maori
    case rar = "Rarotongan; Cook Islands Maori"
    /// Romance languages
    case roa = "Romance languages"
    /// Romansh
    case roh = "Romansh"
    /// Romany
    case rom = "Romany"
    /// Romanian; Moldavian; Moldovan
    case ron = "Romanian; Moldavian; Moldovan"
    /// Rundi
    case run = "Rundi"
    /// Aromanian; Arumanian; Macedo-Romanian
    case rup = "Aromanian; Arumanian; Macedo-Romanian"
    /// Russian
    case rus = "Russian"
    /// Sandawe
    case sad = "Sandawe"
    /// Sango
    case sag = "Sango"
    /// Yakut
    case sah = "Yakut"
    /// South American Indian (Other)
    case sai = "South American Indian (Other)"
    /// Salishan languages
    case sal = "Salishan languages"
    /// Samaritan Aramaic
    case sam = "Samaritan Aramaic"
    /// Sanskrit
    case san = "Sanskrit"
    /// Sasak
    case sas = "Sasak"
    /// Santali
    case sat = "Santali"
    /// Sicilian
    case scn = "Sicilian"
    /// Scots
    case sco = "Scots"
    /// Selkup
    case sel = "Selkup"
    /// Semitic languages
    case sem = "Semitic languages"
    /// Irish, Old (to 900)
    case sga = "Irish, Old (to 900)"
    /// Sign Languages
    case sgn = "Sign Languages"
    /// Shan
    case shn = "Shan"
    /// Sidamo
    case sid = "Sidamo"
    /// Sinhala; Sinhalese
    case sin = "Sinhala; Sinhalese"
    /// Siouan languages
    case sio = "Siouan languages"
    /// Sino-Tibetan languages
    case sit = "Sino-Tibetan languages"
    /// Slavic languages
    case sla = "Slavic languages"
    /// Slovak
    case slk = "Slovak"
    /// Slovenian
    case slv = "Slovenian"
    /// Southern Sami
    case sma = "Southern Sami"
    /// Northern Sami
    case sme = "Northern Sami"
    /// Sami languages
    case smi = "Sami languages"
    /// Lule Sami
    case smj = "Lule Sami"
    /// Inari Sami
    case smn = "Inari Sami"
    /// Samoan
    case smo = "Samoan"
    /// Skolt Sami
    case sms = "Skolt Sami"
    /// Shona
    case sna = "Shona"
    /// Sindhi
    case snd = "Sindhi"
    /// Soninke
    case snk = "Soninke"
    /// Sogdian
    case sog = "Sogdian"
    /// Somali
    case som = "Somali"
    /// Songhai languages
    case son = "Songhai languages"
    /// Sotho, Southern
    case sot = "Sotho, Southern"
    /// Spanish; Castilian
    case spa = "Spanish; Castilian"
    /// Sardinian
    case srd = "Sardinian"
    /// Sranan Tongo
    case srn = "Sranan Tongo"
    /// Serbian
    case srp = "Serbian"
    /// Serer
    case srr = "Serer"
    /// Nilo-Saharan languages
    case ssa = "Nilo-Saharan languages"
    /// Swati
    case ssw = "Swati"
    /// Sukuma
    case suk = "Sukuma"
    /// Sundanese
    case sun = "Sundanese"
    /// Susu
    case sus = "Susu"
    /// Sumerian
    case sux = "Sumerian"
    /// Swahili
    case swa = "Swahili"
    /// Swedish
    case swe = "Swedish"
    /// Classical Syriac
    case syc = "Classical Syriac"
    /// Syriac
    case syr = "Syriac"
    /// Tahitian
    case tah = "Tahitian"
    /// Tai languages
    case tai = "Tai languages"
    /// Tamil
    case tam = "Tamil"
    /// Tatar
    case tat = "Tatar"
    /// Telugu
    case tel = "Telugu"
    /// Timne
    case tem = "Timne"
    /// Tereno
    case ter = "Tereno"
    /// Tetum
    case tet = "Tetum"
    /// Tajik
    case tgk = "Tajik"
    /// Tagalog
    case tgl = "Tagalog"
    /// Thai
    case tha = "Thai"
    /// Tigre
    case tig = "Tigre"
    /// Tigrinya
    case tir = "Tigrinya"
    /// Tiv
    case tiv = "Tiv"
    /// Tokelau
    case tkl = "Tokelau"
    /// Klingon; tlhIngan-Hol
    case tlh = "Klingon; tlhIngan-Hol"
    /// Tlingit
    case tli = "Tlingit"
    /// Tamashek
    case tmh = "Tamashek"
    /// Tonga, Nyasa
    case tog = "Tonga, Nyasa"
    /// Tonga (Tonga Islands)
    case ton = "Tonga (Tonga Islands)"
    /// Tok Pisin
    case tpi = "Tok Pisin"
    /// Tsimshian
    case tsi = "Tsimshian"
    /// Tswana
    case tsn = "Tswana"
    /// Tsonga
    case tso = "Tsonga"
    /// Turkmen
    case tuk = "Turkmen"
    /// Tumbuka
    case tum = "Tumbuka"
    /// Tupi languages
    case tup = "Tupi languages"
    /// Turkish
    case tur = "Turkish"
    /// Altaic languages
    case tut = "Altaic languages"
    /// Tuvalu
    case tvl = "Tuvalu"
    /// Twi
    case twi = "Twi"
    /// Tuvinian
    case tyv = "Tuvinian"
    /// Udmurt
    case udm = "Udmurt"
    /// Ugaritic
    case uga = "Ugaritic"
    /// Uighur; Uyghur
    case uig = "Uighur; Uyghur"
    /// Ukrainian
    case ukr = "Ukrainian"
    /// Umbundu
    case umb = "Umbundu"
    /// Undetermined
    case und = "Undetermined"
    /// Urdu
    case urd = "Urdu"
    /// Uzbek
    case uzb = "Uzbek"
    /// Vai
    case vai = "Vai"
    /// Venda
    case ven = "Venda"
    /// Vietnamese
    case vie = "Vietnamese"
    /// Volapük
    case vol = "Volapük"
    /// Votic
    case vot = "Votic"
    /// Wakashan languages
    case wak = "Wakashan languages"
    /// Wolaitta; Wolaytta
    case wal = "Wolaitta; Wolaytta"
    /// Waray
    case war = "Waray"
    /// Washo
    case was = "Washo"
    /// Sorbian languages
    case wen = "Sorbian languages"
    /// Walloon
    case wln = "Walloon"
    /// Wolof
    case wol = "Wolof"
    /// Kalmyk; Oirat
    case xal = "Kalmyk; Oirat"
    /// Xhosa
    case xho = "Xhosa"
    /// Yao
    case yao = "Yao"
    /// Yapese
    case yap = "Yapese"
    /// Yiddish
    case yid = "Yiddish"
    /// Yoruba
    case yor = "Yoruba"
    /// Yupik languages
    case ypk = "Yupik languages"
    /// Zapotec
    case zap = "Zapotec"
    /// Blissymbols; Blissymbolics; Bliss
    case zbl = "Blissymbols; Blissymbolics; Bliss"
    /// Zenaga
    case zen = "Zenaga"
    /// Standard Moroccan Tamazight
    case zgh = "Standard Moroccan Tamazight"
    /// Zhuang; Chuang
    case zha = "Zhuang; Chuang"
    /// Zande languages
    case znd = "Zande languages"
    /// Zulu
    case zul = "Zulu"
    /// Zuni
    case zun = "Zuni"
    /// No linguistic content; Not applicable
    case zxx = "No linguistic content; Not applicable"
    /// Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki
    case zza = "Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki"
    
    // MARK: ISO-639-2-T Code
    public var iso6392TCode: String {
        switch self {
            /// Afar
            case .aar: return "aar"
            /// Abkhazian
            case .abk: return "abk"
            /// Achinese
            case .ace: return "ace"
            /// Acoli
            case .ach: return "ach"
            /// Adangme
            case .ada: return "ada"
            /// Adyghe; Adygei
            case .ady: return "ady"
            /// Afro-Asiatic languages
            case .afa: return "afa"
            /// Afrihili
            case .afh: return "afh"
            /// Afrikaans
            case .afr: return "afr"
            /// Ainu
            case .ain: return "ain"
            /// Akan
            case .aka: return "aka"
            /// Akkadian
            case .akk: return "akk"
            /// Albanian
            case .sqi: return "sqi"
            /// Aleut
            case .ale: return "ale"
            /// Algonquian languages
            case .alg: return "alg"
            /// Southern Altai
            case .alt: return "alt"
            /// Amharic
            case .amh: return "amh"
            /// English, Old (ca.450–1100)
            case .ang: return "ang"
            /// Angika
            case .anp: return "anp"
            /// Apache languages
            case .apa: return "apa"
            /// Arabic
            case .ara: return "ara"
            /// Official Aramaic, (700–300 BCE); Imperial Aramaic, (700–300 BCE)
            case .arc: return "arc"
            /// Aragonese
            case .arg: return "arg"
            /// Armenian
            case .hye: return "hye"
            /// Mapudungun; Mapuche
            case .arn: return "arn"
            /// Arapaho
            case .arp: return "arp"
            /// Artificial languages
            case .art: return "art"
            /// Arawak
            case .arw: return "arw"
            /// Assamese
            case .asm: return "asm"
            /// Asturian; Bable; Leonese; Asturleonese
            case .ast: return "ast"
            /// Athapascan languages
            case .ath: return "ath"
            /// Australian languages
            case .aus: return "aus"
            /// Avaric
            case .ava: return "ava"
            /// Avestan
            case .ave: return "ave"
            /// Awadhi
            case .awa: return "awa"
            /// Aymara
            case .aym: return "aym"
            /// Azerbaijani
            case .aze: return "aze"
            /// Banda languages
            case .bad: return "bad"
            /// Bamileke languages
            case .bai: return "bai"
            /// Bashkir
            case .bak: return "bak"
            /// Baluchi
            case .bal: return "bal"
            /// Bambara
            case .bam: return "bam"
            /// Balinese
            case .ban: return "ban"
            /// Basque
            case .eus: return "eus"
            /// Basa
            case .bas: return "bas"
            /// Baltic languages
            case .bat: return "bat"
            /// Beja; Bedawiyet
            case .bej: return "bej"
            /// Belarusian
            case .bel: return "bel"
            /// Bemba
            case .bem: return "bem"
            /// Bengali
            case .ben: return "ben"
            /// Berber languages
            case .ber: return "ber"
            /// Bhojpuri
            case .bho: return "bho"
            /// Bihari languages
            case .bih: return "bih"
            /// Bikol
            case .bik: return "bik"
            /// Bini; Edo
            case .bin: return "bin"
            /// Bislama
            case .bis: return "bis"
            /// Siksika
            case .bla: return "bla"
            /// Bantu (Other)
            case .bnt: return "bnt"
            /// Tibetan
            case .bod: return "bod"
            /// Bosnian
            case .bos: return "bos"
            /// Braj
            case .bra: return "bra"
            /// Breton
            case .bre: return "bre"
            /// Batak languages
            case .btk: return "btk"
            /// Buriat
            case .bua: return "bua"
            /// Buginese
            case .bug: return "bug"
            /// Bulgarian
            case .bul: return "bul"
            /// Burmese
            case .mya: return "mya"
            /// Blin; Bilin
            case .byn: return "byn"
            /// Caddo
            case .cad: return "cad"
            /// Central American Indian languages
            case .cai: return "cai"
            /// Galibi Carib
            case .car: return "car"
            /// Catalan; Valencian
            case .cat: return "cat"
            /// Caucasian languages
            case .cau: return "cau"
            /// Cebuano
            case .ceb: return "ceb"
            /// Celtic languages
            case .cel: return "cel"
            /// Czech
            case .ces: return "ces"
            /// Chamorro
            case .cha: return "cha"
            /// Chibcha
            case .chb: return "chb"
            /// Chechen
            case .che: return "che"
            /// Chagatai
            case .chg: return "chg"
            /// Chinese
            case .zho: return "zho"
            /// Chuukese
            case .chk: return "chk"
            /// Mari
            case .chm: return "chm"
            /// Chinook jargon
            case .chn: return "chn"
            /// Choctaw
            case .cho: return "cho"
            /// Chipewyan; Dene Suline
            case .chp: return "chp"
            /// Cherokee
            case .chr: return "chr"
            /// Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic
            case .chu: return "chu"
            /// Chuvash
            case .chv: return "chv"
            /// Cheyenne
            case .chy: return "chy"
            /// Chamic languages
            case .cmc: return "cmc"
            /// Montenegrin
            case .cnr: return "cnr"
            /// Coptic
            case .cop: return "cop"
            /// Cornish
            case .cor: return "cor"
            /// Corsican
            case .cos: return "cos"
            /// Creoles and pidgins, English based
            case .cpe: return "cpe"
            /// Creoles and pidgins, French-based
            case .cpf: return "cpf"
            /// Creoles and pidgins, Portuguese-based
            case .cpp: return "cpp"
            /// Cree
            case .cre: return "cre"
            /// Crimean Tatar; Crimean Turkish
            case .crh: return "crh"
            /// Creoles and pidgins
            case .crp: return "crp"
            /// Kashubian
            case .csb: return "csb"
            /// Cushitic languages
            case .cus: return "cus"
            /// Welsh
            case .cym: return "cym"
            /// Dakota
            case .dak: return "dak"
            /// Danish
            case .dan: return "dan"
            /// Dargwa
            case .dar: return "dar"
            /// Land Dayak languages
            case .day: return "day"
            /// Delaware
            case .del: return "del"
            /// Slave (isoName: Athapascan)
            case .den: return "den"
            /// German
            case .deu: return "deu"
            /// Dogrib
            case .dgr: return "dgr"
            /// Dinka
            case .din: return "din"
            /// Divehi; Dhivehi; Maldivian
            case .div: return "div"
            /// Dogri
            case .doi: return "doi"
            /// Dravidian languages
            case .dra: return "dra"
            /// Lower Sorbian
            case .dsb: return "dsb"
            /// Duala
            case .dua: return "dua"
            /// Dutch, Middle (ca. 1050–1350)
            case .dum: return "dum"
            /// Dutch; Flemish
            case .nld: return "nld"
            /// Dyula
            case .dyu: return "dyu"
            /// Dzongkha
            case .dzo: return "dzo"
            /// Efik
            case .efi: return "efi"
            /// Egyptian (Ancient)
            case .egy: return "egy"
            /// Ekajuk
            case .eka: return "eka"
            /// Greek, Modern (1453–)
            case .ell: return "ell"
            /// Elamite
            case .elx: return "elx"
            /// English
            case .eng: return "eng"
            /// English, Middle (1100–1500)
            case .enm: return "enm"
            /// Esperanto
            case .epo: return "epo"
            /// Estonian
            case .est: return "est"
            /// Ewe
            case .ewe: return "ewe"
            /// Ewondo
            case .ewo: return "ewo"
            /// Fang
            case .fan: return "fan"
            /// Faroese
            case .fao: return "fao"
            /// Persian
            case .fas: return "fas"
            /// Fanti
            case .fat: return "fat"
            /// Fijian
            case .fij: return "fij"
            /// Filipino; Pilipino
            case .fil: return "fil"
            /// Finnish
            case .fin: return "fin"
            /// Finno-Ugrian languages
            case .fiu: return "fiu"
            /// Fon
            case .fon: return "fon"
            /// French
            case .fra: return "fra"
            /// French, Middle (ca. 1400–1600)
            case .frm: return "frm"
            /// French, Old (842–ca. 1400)
            case .fro: return "fro"
            /// Northern Frisian
            case .frr: return "frr"
            /// Eastern Frisian
            case .frs: return "frs"
            /// Western Frisian
            case .fry: return "fry"
            /// Fulah
            case .ful: return "ful"
            /// Friulian
            case .fur: return "fur"
            /// Ga
            case .gaa: return "gaa"
            /// Gayo
            case .gay: return "gay"
            /// Gbaya
            case .gba: return "gba"
            /// Germanic languages
            case .gem: return "gem"
            /// Georgian
            case .kat: return "kat"
            /// Geez
            case .gez: return "gez"
            /// Gilbertese
            case .gil: return "gil"
            /// Gaelic; Scottish Gaelic
            case .gla: return "gla"
            /// Irish
            case .gle: return "gle"
            /// Galician
            case .glg: return "glg"
            /// Manx
            case .glv: return "glv"
            /// German, Middle High (ca. 1050–1500)
            case .gmh: return "gmh"
            /// German, Old High (ca. 750–1050)
            case .goh: return "goh"
            /// Gondi
            case .gon: return "gon"
            /// Gorontalo
            case .gor: return "gor"
            /// Gothic
            case .got: return "got"
            /// Grebo
            case .grb: return "grb"
            /// Greek, Ancient (to 1453)
            case .grc: return "grc"
            /// Guarani
            case .grn: return "grn"
            /// Swiss German; Alemannic; Alsatian
            case .gsw: return "gsw"
            /// Gujarati
            case .guj: return "guj"
            /// Gwich'in
            case .gwi: return "gwi"
            /// Haida
            case .hai: return "hai"
            /// Haitian; Haitian Creole
            case .hat: return "hat"
            /// Hausa
            case .hau: return "hau"
            /// Hawaiian
            case .haw: return "haw"
            /// Hebrew
            case .heb: return "heb"
            /// Herero
            case .her: return "her"
            /// Hiligaynon
            case .hil: return "hil"
            /// Himachali languages; Pahari languages
            case .him: return "him"
            /// Hindi
            case .hin: return "hin"
            /// Hittite
            case .hit: return "hit"
            /// Hmong; Mong
            case .hmn: return "hmn"
            /// Hiri Motu
            case .hmo: return "hmo"
            /// Croatian
            case .hrv: return "hrv"
            /// Upper Sorbian
            case .hsb: return "hsb"
            /// Hungarian
            case .hun: return "hun"
            /// Hupa
            case .hup: return "hup"
            /// Iban
            case .iba: return "iba"
            /// Igbo
            case .ibo: return "ibo"
            /// Icelandic
            case .isl: return "isl"
            /// Ido
            case .ido: return "ido"
            /// Sichuan Yi; Nuosu
            case .iii: return "iii"
            /// Ijo languages
            case .ijo: return "ijo"
            /// Inuktitut
            case .iku: return "iku"
            /// Interlingue; Occidental
            case .ile: return "ile"
            /// Iloko
            case .ilo: return "ilo"
            /// Interlingua (International Auxiliary Language Association)
            case .ina: return "ina"
            /// Indic languages
            case .inc: return "inc"
            /// Indonesian
            case .ind: return "ind"
            /// Indo-European languages
            case .ine: return "ine"
            /// Ingush
            case .inh: return "inh"
            /// Inupiaq
            case .ipk: return "ipk"
            /// Iranian languages
            case .ira: return "ira"
            /// Iroquoian languages
            case .iro: return "iro"
            /// Italian
            case .ita: return "ita"
            /// Javanese
            case .jav: return "jav"
            /// Lojban
            case .jbo: return "jbo"
            /// Japanese
            case .jpn: return "jpn"
            /// Judeo-Persian
            case .jpr: return "jpr"
            /// Judeo-Arabic
            case .jrb: return "jrb"
            /// Kara-Kalpak
            case .kaa: return "kaa"
            /// Kabyle
            case .kab: return "kab"
            /// Kachin; Jingpho
            case .kac: return "kac"
            /// Kalaallisut; Greenlandic
            case .kal: return "kal"
            /// Kamba
            case .kam: return "kam"
            /// Kannada
            case .kan: return "kan"
            /// Karen languages
            case .kar: return "kar"
            /// Kashmiri
            case .kas: return "kas"
            /// Kanuri
            case .kau: return "kau"
            /// Kawi
            case .kaw: return "kaw"
            /// Kazakh
            case .kaz: return "kaz"
            /// Kabardian
            case .kbd: return "kbd"
            /// Khasi
            case .kha: return "kha"
            /// Khoisan languages
            case .khi: return "khi"
            /// Central Khmer
            case .khm: return "khm"
            /// Khotanese; Sakan
            case .kho: return "kho"
            /// Kikuyu; Gikuyu
            case .kik: return "kik"
            /// Kinyarwanda
            case .kin: return "kin"
            /// Kirghiz; Kyrgyz
            case .kir: return "kir"
            /// Kimbundu
            case .kmb: return "kmb"
            /// Konkani
            case .kok: return "kok"
            /// Komi
            case .kom: return "kom"
            /// Kongo
            case .kon: return "kon"
            /// Korean
            case .kor: return "kor"
            /// Kosraean
            case .kos: return "kos"
            /// Kpelle
            case .kpe: return "kpe"
            /// Karachay-Balkar
            case .krc: return "krc"
            /// Karelian
            case .krl: return "krl"
            /// Kru languages
            case .kro: return "kro"
            /// Kurukh
            case .kru: return "kru"
            /// Kuanyama; Kwanyama
            case .kua: return "kua"
            /// Kumyk
            case .kum: return "kum"
            /// Kurdish
            case .kur: return "kur"
            /// Kutenai
            case .kut: return "kut"
            /// Ladino
            case .lad: return "lad"
            /// Lahnda
            case .lah: return "lah"
            /// Lamba
            case .lam: return "lam"
            /// Lao
            case .lao: return "lao"
            /// Latin
            case .lat: return "lat"
            /// Latvian
            case .lav: return "lav"
            /// Lezghian
            case .lez: return "lez"
            /// Limburgan; Limburger; Limburgish
            case .lim: return "lim"
            /// Lingala
            case .lin: return "lin"
            /// Lithuanian
            case .lit: return "lit"
            /// Mongo
            case .lol: return "lol"
            /// Lozi
            case .loz: return "loz"
            /// Luxembourgish; Letzeburgesch
            case .ltz: return "ltz"
            /// Luba-Lulua
            case .lua: return "lua"
            /// Luba-Katanga
            case .lub: return "lub"
            /// Ganda
            case .lug: return "lug"
            /// Luiseno
            case .lui: return "lui"
            /// Lunda
            case .lun: return "lun"
            /// Luo (Kenya and Tanzania)
            case .luo: return "luo"
            /// Lushai
            case .lus: return "lus"
            /// Macedonian
            case .mkd: return "mkd"
            /// Madurese
            case .mad: return "mad"
            /// Magahi
            case .mag: return "mag"
            /// Marshallese
            case .mah: return "mah"
            /// Maithili
            case .mai: return "mai"
            /// Makasar
            case .mak: return "mak"
            /// Malayalam
            case .mal: return "mal"
            /// Mandingo
            case .man: return "man"
            /// Maori
            case .mri: return "mri"
            /// Austronesian languages
            case .map: return "map"
            /// Marathi
            case .mar: return "mar"
            /// Masai
            case .mas: return "mas"
            /// Malay
            case .msa: return "msa"
            /// Moksha
            case .mdf: return "mdf"
            /// Mandar
            case .mdr: return "mdr"
            /// Mende
            case .men: return "men"
            /// Irish, Middle (900–1200)
            case .mga: return "mga"
            /// Mi'kmaq; Micmac
            case .mic: return "mic"
            /// Minangkabau
            case .min: return "min"
            /// Uncoded languages
            case .mis: return "mis"
            /// Mon-Khmer languages
            case .mkh: return "mkh"
            /// Malagasy
            case .mlg: return "mlg"
            /// Maltese
            case .mlt: return "mlt"
            /// Manchu
            case .mnc: return "mnc"
            /// Manipuri
            case .mni: return "mni"
            /// Manobo languages
            case .mno: return "mno"
            /// Mohawk
            case .moh: return "moh"
            /// Mongolian
            case .mon: return "mon"
            /// Mossi
            case .mos: return "mos"
            /// Multiple languages
            case .mul: return "mul"
            /// Munda languages
            case .mun: return "mun"
            /// Creek
            case .mus: return "mus"
            /// Mirandese
            case .mwl: return "mwl"
            /// Marwari
            case .mwr: return "mwr"
            /// Mayan languages
            case .myn: return "myn"
            /// Erzya
            case .myv: return "myv"
            /// Nahuatl languages
            case .nah: return "nah"
            /// North American Indian languages
            case .nai: return "nai"
            /// Neapolitan
            case .nap: return "nap"
            /// Nauru
            case .nau: return "nau"
            /// Navajo; Navaho
            case .nav: return "nav"
            /// Ndebele, South; South Ndebele
            case .nbl: return "nbl"
            /// Ndebele, North; North Ndebele
            case .nde: return "nde"
            /// Ndonga
            case .ndo: return "ndo"
            /// Low German; Low Saxon; German, Low; Saxon, Low
            case .nds: return "nds"
            /// Nepali
            case .nep: return "nep"
            /// Nepal Bhasa; Newari
            case .new: return "new"
            /// Nias
            case .nia: return "nia"
            /// Niger-Kordofanian languages
            case .nic: return "nic"
            /// Niuean
            case .niu: return "niu"
            /// Norwegian Nynorsk; Nynorsk, Norwegian
            case .nno: return "nno"
            /// Bokmål, Norwegian; Norwegian Bokmål
            case .nob: return "nob"
            /// Nogai
            case .nog: return "nog"
            /// Norse, Old
            case .non: return "non"
            /// Norwegian
            case .nor: return "nor"
            /// N'Ko
            case .nqo: return "nqo"
            /// Pedi; Sepedi; Northern Sotho
            case .nso: return "nso"
            /// Nubian languages
            case .nub: return "nub"
            /// Classical Newari; Old Newari; Classical Nepal Bhasa
            case .nwc: return "nwc"
            /// Chichewa; Chewa; Nyanja
            case .nya: return "nya"
            /// Nyamwezi
            case .nym: return "nym"
            /// Nyankole
            case .nyn: return "nyn"
            /// Nyoro
            case .nyo: return "nyo"
            /// Nzima
            case .nzi: return "nzi"
            /// Occitan (post 1500); Provençal
            case .oci: return "oci"
            /// Ojibwa
            case .oji: return "oji"
            /// Oriya
            case .ori: return "ori"
            /// Oromo
            case .orm: return "orm"
            /// Osage
            case .osa: return "osa"
            /// Ossetian; Ossetic
            case .oss: return "oss"
            /// Turkish, Ottoman (1500–1928)
            case .ota: return "ota"
            /// Otomian languages
            case .oto: return "oto"
            /// Papuan languages
            case .paa: return "paa"
            /// Pangasinan
            case .pag: return "pag"
            /// Pahlavi
            case .pal: return "pal"
            /// Pampanga; Kapampangan
            case .pam: return "pam"
            /// Panjabi; Punjabi
            case .pan: return "pan"
            /// Papiamento
            case .pap: return "pap"
            /// Palauan
            case .pau: return "pau"
            /// Persian, Old (ca. 600–400 B.C.)
            case .peo: return "peo"
            /// Philippine languages
            case .phi: return "phi"
            /// Phoenician
            case .phn: return "phn"
            /// Pali
            case .pli: return "pli"
            /// Polish
            case .pol: return "pol"
            /// Pohnpeian
            case .pon: return "pon"
            /// Portuguese
            case .por: return "por"
            /// Prakrit languages
            case .pra: return "pra"
            /// Provençal, Old (to 1500); Old Occitan (to 1500)
            case .pro: return "pro"
            /// Pushto; Pashto
            case .pus: return "pus"
            /// Quechua
            case .que: return "que"
            /// Rajasthani
            case .raj: return "raj"
            /// Rapanui
            case .rap: return "rap"
            /// Rarotongan; Cook Islands Maori
            case .rar: return "rar"
            /// Romance languages
            case .roa: return "roa"
            /// Romansh
            case .roh: return "roh"
            /// Romany
            case .rom: return "rom"
            /// Romanian; Moldavian; Moldovan
            case .ron: return "ron"
            /// Rundi
            case .run: return "run"
            /// Aromanian; Arumanian; Macedo-Romanian
            case .rup: return "rup"
            /// Russian
            case .rus: return "rus"
            /// Sandawe
            case .sad: return "sad"
            /// Sango
            case .sag: return "sag"
            /// Yakut
            case .sah: return "sah"
            /// South American Indian (Other)
            case .sai: return "sai"
            /// Salishan languages
            case .sal: return "sal"
            /// Samaritan Aramaic
            case .sam: return "sam"
            /// Sanskrit
            case .san: return "san"
            /// Sasak
            case .sas: return "sas"
            /// Santali
            case .sat: return "sat"
            /// Sicilian
            case .scn: return "scn"
            /// Scots
            case .sco: return "sco"
            /// Selkup
            case .sel: return "sel"
            /// Semitic languages
            case .sem: return "sem"
            /// Irish, Old (to 900)
            case .sga: return "sga"
            /// Sign Languages
            case .sgn: return "sgn"
            /// Shan
            case .shn: return "shn"
            /// Sidamo
            case .sid: return "sid"
            /// Sinhala; Sinhalese
            case .sin: return "sin"
            /// Siouan languages
            case .sio: return "sio"
            /// Sino-Tibetan languages
            case .sit: return "sit"
            /// Slavic languages
            case .sla: return "sla"
            /// Slovak
            case .slk: return "slk"
            /// Slovenian
            case .slv: return "slv"
            /// Southern Sami
            case .sma: return "sma"
            /// Northern Sami
            case .sme: return "sme"
            /// Sami languages
            case .smi: return "smi"
            /// Lule Sami
            case .smj: return "smj"
            /// Inari Sami
            case .smn: return "smn"
            /// Samoan
            case .smo: return "smo"
            /// Skolt Sami
            case .sms: return "sms"
            /// Shona
            case .sna: return "sna"
            /// Sindhi
            case .snd: return "snd"
            /// Soninke
            case .snk: return "snk"
            /// Sogdian
            case .sog: return "sog"
            /// Somali
            case .som: return "som"
            /// Songhai languages
            case .son: return "son"
            /// Sotho, Southern
            case .sot: return "sot"
            /// Spanish; Castilian
            case .spa: return "spa"
            /// Sardinian
            case .srd: return "srd"
            /// Sranan Tongo
            case .srn: return "srn"
            /// Serbian
            case .srp: return "srp"
            /// Serer
            case .srr: return "srr"
            /// Nilo-Saharan languages
            case .ssa: return "ssa"
            /// Swati
            case .ssw: return "ssw"
            /// Sukuma
            case .suk: return "suk"
            /// Sundanese
            case .sun: return "sun"
            /// Susu
            case .sus: return "sus"
            /// Sumerian
            case .sux: return "sux"
            /// Swahili
            case .swa: return "swa"
            /// Swedish
            case .swe: return "swe"
            /// Classical Syriac
            case .syc: return "syc"
            /// Syriac
            case .syr: return "syr"
            /// Tahitian
            case .tah: return "tah"
            /// Tai languages
            case .tai: return "tai"
            /// Tamil
            case .tam: return "tam"
            /// Tatar
            case .tat: return "tat"
            /// Telugu
            case .tel: return "tel"
            /// Timne
            case .tem: return "tem"
            /// Tereno
            case .ter: return "ter"
            /// Tetum
            case .tet: return "tet"
            /// Tajik
            case .tgk: return "tgk"
            /// Tagalog
            case .tgl: return "tgl"
            /// Thai
            case .tha: return "tha"
            /// Tigre
            case .tig: return "tig"
            /// Tigrinya
            case .tir: return "tir"
            /// Tiv
            case .tiv: return "tiv"
            /// Tokelau
            case .tkl: return "tkl"
            /// Klingon; tlhIngan-Hol
            case .tlh: return "tlh"
            /// Tlingit
            case .tli: return "tli"
            /// Tamashek
            case .tmh: return "tmh"
            /// Tonga, Nyasa
            case .tog: return "tog"
            /// Tonga (Tonga Islands)
            case .ton: return "ton"
            /// Tok Pisin
            case .tpi: return "tpi"
            /// Tsimshian
            case .tsi: return "tsi"
            /// Tswana
            case .tsn: return "tsn"
            /// Tsonga
            case .tso: return "tso"
            /// Turkmen
            case .tuk: return "tuk"
            /// Tumbuka
            case .tum: return "tum"
            /// Tupi languages
            case .tup: return "tup"
            /// Turkish
            case .tur: return "tur"
            /// Altaic languages
            case .tut: return "tut"
            /// Tuvalu
            case .tvl: return "tvl"
            /// Twi
            case .twi: return "twi"
            /// Tuvinian
            case .tyv: return "tyv"
            /// Udmurt
            case .udm: return "udm"
            /// Ugaritic
            case .uga: return "uga"
            /// Uighur; Uyghur
            case .uig: return "uig"
            /// Ukrainian
            case .ukr: return "ukr"
            /// Umbundu
            case .umb: return "umb"
            /// Undetermined
            case .und: return "und"
            /// Urdu
            case .urd: return "urd"
            /// Uzbek
            case .uzb: return "uzb"
            /// Vai
            case .vai: return "vai"
            /// Venda
            case .ven: return "ven"
            /// Vietnamese
            case .vie: return "vie"
            /// Volapük
            case .vol: return "vol"
            /// Votic
            case .vot: return "vot"
            /// Wakashan languages
            case .wak: return "wak"
            /// Wolaitta; Wolaytta
            case .wal: return "wal"
            /// Waray
            case .war: return "war"
            /// Washo
            case .was: return "was"
            /// Sorbian languages
            case .wen: return "wen"
            /// Walloon
            case .wln: return "wln"
            /// Wolof
            case .wol: return "wol"
            /// Kalmyk; Oirat
            case .xal: return "xal"
            /// Xhosa
            case .xho: return "xho"
            /// Yao
            case .yao: return "yao"
            /// Yapese
            case .yap: return "yap"
            /// Yiddish
            case .yid: return "yid"
            /// Yoruba
            case .yor: return "yor"
            /// Yupik languages
            case .ypk: return "ypk"
            /// Zapotec
            case .zap: return "zap"
            /// Blissymbols; Blissymbolics; Bliss
            case .zbl: return "zbl"
            /// Zenaga
            case .zen: return "zen"
            /// Standard Moroccan Tamazight
            case .zgh: return "zgh"
            /// Zhuang; Chuang
            case .zha: return "zha"
            /// Zande languages
            case .znd: return "znd"
            /// Zulu
            case .zul: return "zul"
            /// Zuni
            case .zun: return "zun"
            /// No linguistic content; Not applicable
            case .zxx: return "zxx"
            /// Zaza; Dimili; Dimli; Kirdki; Kirmanjki; Zazaki
            case .zza: return "zza"
        }
    }
    
    // MARK: Native Name
    public var nativeName: String {
        switch self {
            /// Afar
            case .aar: return "Qafaraf; ’Afar Af; Afaraf; Qafar af"
            /// Abkhazian
            case .abk: return "Аҧсуа бызшәа; Аҧсшәа"
            /// Achinese
            case .ace: return "بهسا اچيه"
            /// Acoli
            case .ach: return "Lwo"
            /// Adangme
            case .ada: return "Dangme"
            /// Adyghe; Adygei
            case .ady: return "Адыгабзэ; Кӏахыбзэ"
            /// Afrihili
            case .afh: return "El-Afrihili"
            /// Ainu
            case .ain: return "アイヌ・イタㇰ"
            /// Akkadian
            case .akk: return "𒀝𒅗𒁺𒌑"
            /// Albanian
            case .sqi: return "Shqip"
            /// Aleut
            case .ale: return "Уна́ӈам тунуу́; Унаӈан умсуу"
            /// Southern Altai
            case .alt: return "Алтай тили"
            /// Amharic
            case .amh: return "አማርኛ"
            /// English, Old (ca.450–1100)
            case .ang: return "Ænglisc; Anglisc; Englisc"
            /// Arabic
            case .ara: return "العَرَبِيَّة"
            /// Aragonese
            case .arg: return "aragonés"
            /// Armenian
            case .hye: return "Հայերէն; Հայերեն"
            /// Arapaho
            case .arp: return "Hinónoʼeitíít"
            /// Arawak
            case .arw: return "Lokono"
            /// Assamese
            case .asm: return "অসমীয়া"
            /// Asturian; Bable; Leonese; Asturleonese
            case .ast: return "Asturianu"
            /// Avaric
            case .ava: return "Магӏарул мацӏ; Авар мацӏ"
            /// Awadhi
            case .awa: return "अवधी"
            /// Aymara
            case .aym: return "Aymar aru"
            /// Azerbaijani
            case .aze: return "Azərbaycan dili; آذربایجان دیلی; Азәрбајҹан дили"
            /// Bamileke languages
            case .bai: return "Bamiléké"
            /// Bashkir
            case .bak: return "Башҡорт теле; Başqort tele"
            /// Baluchi
            case .bal: return "بلوچی"
            /// Bambara
            case .bam: return "ߓߊߡߊߣߊߣߞߊߣ"
            /// Balinese
            case .ban: return "ᬪᬵᬱᬩᬮᬶ; ᬩᬲᬩᬮᬶ"
            /// Basque
            case .eus: return "euskara"
            /// Basa
            case .bas: return "Mbene; Ɓasaá"
            /// Beja; Bedawiyet
            case .bej: return "Bidhaawyeet"
            /// Belarusian
            case .bel: return "Беларуская мова"
            /// Bemba
            case .bem: return "Chibemba"
            /// Bengali
            case .ben: return "বাংলা"
            /// Berber languages
            case .ber: return "Tamaziɣt; Tamazight; ⵜⴰⵎⴰⵣⵉⵖⵜ; ⵝⴰⵎⴰⵣⵉⵗⵝ; ⵜⴰⵎⴰⵣⵉⵗⵜ"
            /// Bhojpuri
            case .bho: return "भोजपुरी"
            /// Bini; Edo
            case .bin: return "Ẹ̀dó"
            /// Siksika
            case .bla: return "ᓱᖽᐧᖿ"
            /// Tibetan
            case .bod: return "བོད་སྐད་; ལྷ་སའི་སྐད་"
            /// Bosnian
            case .bos: return "bosanski; босански"
            /// Breton
            case .bre: return "Brezhoneg"
            /// Buriat
            case .bua: return "буряад хэлэн"
            /// Buginese
            case .bug: return "ᨅᨔ ᨕᨘᨁᨗ"
            /// Bulgarian
            case .bul: return "български език"
            /// Burmese
            case .mya: return "မြန်မာစာ; မြန်မာစကား"
            /// Blin; Bilin
            case .byn: return "ብሊና; ብሊን"
            /// Caddo
            case .cad: return "Hasí:nay"
            /// Galibi Carib
            case .car: return "Kari'nja"
            /// Catalan; Valencian
            case .cat: return "català"
            /// Cebuano
            case .ceb: return "Sinugbuanong Binisayâ"
            /// Czech
            case .ces: return "čeština; český jazyk"
            /// Chamorro
            case .cha: return "Finu' Chamoru"
            /// Chibcha
            case .chb: return "Muysccubun"
            /// Chechen
            case .che: return "Нохчийн мотт; نَاخچیین موٓتت; ნახჩიე მუოთთ"
            /// Chagatai
            case .chg: return "جغتای"
            /// Chinese
            case .zho: return "中文; 汉语; 漢語"
            /// Mari
            case .chm: return "марий йылме"
            /// Chinook jargon
            case .chn: return "chinuk wawa; wawa; chinook lelang; lelang"
            /// Choctaw
            case .cho: return "Chahta'"
            /// Chipewyan; Dene Suline
            case .chp: return "ᑌᓀᓱᒼᕄᓀ (Dënesųłiné)"
            /// Cherokee
            case .chr: return "ᏣᎳᎩ ᎦᏬᏂᎯᏍᏗ"
            /// Church Slavic; Old Slavonic; Church Slavonic; Old Bulgarian; Old Church Slavonic
            case .chu: return "Славе́нскїй ѧ҆зы́къ"
            /// Chuvash
            case .chv: return "Чӑвашла"
            /// Cheyenne
            case .chy: return "Tsėhésenėstsestȯtse"
            /// Montenegrin
            case .cnr: return "crnogorski / црногорски"
            /// Coptic
            case .cop: return "ϯⲙⲉⲑⲣⲉⲙⲛ̀ⲭⲏⲙⲓ; ⲧⲙⲛ̄ⲧⲣⲙ̄ⲛ̄ⲕⲏⲙⲉ"
            /// Cornish
            case .cor: return "Kernowek"
            /// Corsican
            case .cos: return "Corsu; Lingua corsa"
            /// Crimean Tatar; Crimean Turkish
            case .crh: return "Къырымтатарджа; Къырымтатар тили; Ҡырымтатарҗа; Ҡырымтатар тили"
            /// Kashubian
            case .csb: return "Kaszëbsczi jãzëk"
            /// Welsh
            case .cym: return "Cymraeg; y Gymraeg"
            /// Dakota
            case .dak: return "Dakhótiyapi; Dakȟótiyapi"
            /// Danish
            case .dan: return "dansk"
            /// Dargwa
            case .dar: return "дарган мез"
            /// Slave (isoName: Athapascan)
            case .den: return "Dene K'e"
            /// German
            case .deu: return "Deutsch"
            /// Dogrib
            case .dgr: return "डोगरी; ڈوگرى"
            /// Dinka
            case .din: return "Thuɔŋjäŋ"
            /// Divehi; Dhivehi; Maldivian
            case .div: return "ދިވެހި; ދިވެހިބަސް"
            /// Dogri
            case .doi: return "डोगरी; ڈوگرى"
            /// Lower Sorbian
            case .dsb: return "Dolnoserbski; Dolnoserbšćina"
            /// Dutch; Flemish
            case .nld: return "Nederlands; Vlaams"
            /// Dyula
            case .dyu: return "Julakan"
            /// Dzongkha
            case .dzo: return "རྫོང་ཁ་"
            /// Egyptian (Ancient)
            case .egy: return "Egyptian (isAncient)"
            /// Greek, Modern (1453–)
            case .ell: return "Νέα Ελληνικά"
            /// Estonian
            case .est: return "eesti keel"
            /// Ewe
            case .ewe: return "Èʋegbe"
            /// Faroese
            case .fao: return "føroyskt"
            /// Persian
            case .fas: return "فارسی"
            /// Fanti
            case .fat: return "Mfantse; Fante; Fanti"
            /// Fijian
            case .fij: return "Na Vosa Vakaviti"
            /// Filipino; Pilipino
            case .fil: return "Wikang Filipino"
            /// Finnish
            case .fin: return "suomen kieli"
            /// Fon
            case .fon: return "Fon gbè"
            /// French
            case .fra: return "français"
            /// French, Middle (ca. 1400–1600)
            case .frm: return "françois; franceis"
            /// French, Old (842–ca. 1400)
            case .fro: return "Franceis; François; Romanz"
            /// Northern Frisian
            case .frr: return "Frasch; Fresk; Freesk; Friisk"
            /// Eastern Frisian
            case .frs: return "Seeltersk"
            /// Western Frisian
            case .fry: return "Frysk"
            /// Fulah
            case .ful: return "Fulfulde; Pulaar; Pular"
            /// Friulian
            case .fur: return "Furlan"
            /// Ga
            case .gaa: return "Gã"
            /// Gayo
            case .gay: return "Basa Gayo"
            /// Georgian
            case .kat: return "ქართული"
            /// Geez
            case .gez: return "ግዕዝ"
            /// Gilbertese
            case .gil: return "Taetae ni Kiribati"
            /// Gaelic; Scottish Gaelic
            case .gla: return "Gàidhlig"
            /// Irish
            case .gle: return "Gaeilge"
            /// Galician
            case .glg: return "galego"
            /// Manx
            case .glv: return "Gaelg; Gailck"
            /// German, Middle High (ca. 1050–1500)
            case .gmh: return "Diutsch"
            /// German, Old High (ca. 750–1050)
            case .goh: return "Diutisk"
            /// Gorontalo
            case .gor: return "Bahasa Hulontalo"
            /// Greek, Ancient (to 1453)
            case .grc: return "Ἑλληνική"
            /// Guarani
            case .grn: return "Avañe'ẽ"
            /// Swiss German; Alemannic; Alsatian
            case .gsw: return "Schwiizerdütsch"
            /// Gujarati
            case .guj: return "ગુજરાતી"
            /// Gwich'in
            case .gwi: return "Dinjii Zhu’ Ginjik"
            /// Haida
            case .hai: return "X̱aat Kíl; X̱aadas Kíl; X̱aayda Kil; Xaad kil"
            /// Haitian; Haitian Creole
            case .hat: return "kreyòl ayisyen"
            /// Hausa
            case .hau: return "Harshen Hausa; هَرْشَن"
            /// Hawaiian
            case .haw: return "ʻŌlelo Hawaiʻi"
            /// Hebrew
            case .heb: return "עברית"
            /// Herero
            case .her: return "Otjiherero"
            /// Hiligaynon
            case .hil: return "Ilonggo"
            /// Hindi
            case .hin: return "हिन्दी"
            /// Hittite
            case .hit: return "𒉈𒅆𒇷"
            /// Hmong; Mong
            case .hmn: return "lus Hmoob; lug Moob; lol Hmongb"
            /// Croatian
            case .hrv: return "hrvatski"
            /// Upper Sorbian
            case .hsb: return "hornjoserbšćina"
            /// Hungarian
            case .hun: return "magyar nyelv"
            /// Hupa
            case .hup: return "Na:tinixwe Mixine:whe'"
            /// Iban
            case .iba: return "Jaku Iban"
            /// Igbo
            case .ibo: return "Asụsụ Igbo"
            /// Icelandic
            case .isl: return "íslenska"
            /// Sichuan Yi; Nuosu
            case .iii: return "ꆈꌠꉙ"
            /// Ijo languages
            case .ijo: return "Ịjọ"
            /// Inuktitut
            case .iku: return "ᐃᓄᒃᑎᑐᑦ"
            /// Iloko
            case .ilo: return "Pagsasao nga Ilokano; Ilokano"
            /// Indonesian
            case .ind: return "bahasa Indonesia"
            /// Ingush
            case .inh: return "ГӀалгӀай мотт"
            /// Inupiaq
            case .ipk: return "Iñupiaq"
            /// Italian
            case .ita: return "italiano; lingua italiana"
            /// Javanese
            case .jav: return "ꦧꦱꦗꦮ"
            /// Lojban
            case .jbo: return "la .lojban."
            /// Japanese
            case .jpn: return "日本語"
            /// Judeo-Persian
            case .jpr: return "Dzhidi"
            /// Judeo-Arabic
            case .jrb: return "عربية يهودية / ערבית יהודית"
            /// Kara-Kalpak
            case .kaa: return "Qaraqalpaq tili; Қарақалпақ тили"
            /// Kabyle
            case .kab: return "Tamaziɣt Taqbaylit; Tazwawt"
            /// Kachin; Jingpho
            case .kac: return "Jingpho"
            /// Kannada
            case .kan: return "ಕನ್ನಡ"
            /// Kashmiri
            case .kas: return "कॉशुर / كأشُر"
            /// Kawi
            case .kaw: return "ꦧꦱꦗꦮ"
            /// Kazakh
            case .kaz: return "қазақ тілі / qazaq tili"
            /// Kabardian
            case .kbd: return "Адыгэбзэ (Къэбэрдейбзэ)"
            /// Khasi
            case .kha: return "কা কতিয়েন খাশি"
            /// Central Khmer
            case .khm: return "ភាសាខ្មែរ"
            /// Kikuyu; Gikuyu
            case .kik: return "Gĩkũyũ"
            /// Kirghiz; Kyrgyz
            case .kir: return "кыргызча; кыргыз тили"
            /// Konkani
            case .kok: return "कोंकणी"
            /// Komi
            case .kom: return "Коми кыв"
            /// Korean
            case .kor: return "한국어"
            /// Kpelle
            case .kpe: return "Kpɛlɛwoo"
            /// Karachay-Balkar
            case .krc: return "Къарачай-Малкъар тил; Таулу тил"
            /// Karelian
            case .krl: return "karjal; kariela; karjala"
            /// Kurukh
            case .kru: return "कुड़ुख़"
            /// Kumyk
            case .kum: return "къумукъ тил/qumuq til"
            /// Kurdish
            case .kur: return "Kurdî / کوردی"
            /// Ladino
            case .lad: return "Judeo-español"
            /// Lahnda
            case .lah: return "بھارت کا"
            /// Lao
            case .lao: return "ພາສາລາວ"
            /// Latin
            case .lat: return "Lingua latīna"
            /// Latvian
            case .lav: return "Latviešu valoda"
            /// Lezghian
            case .lez: return "Лезги чӏал"
            /// Limburgan; Limburger; Limburgish
            case .lim: return "Lèmburgs"
            /// Lithuanian
            case .lit: return "lietuvių kalba"
            /// Mongo
            case .lol: return "Lomongo"
            /// Luxembourgish; Letzeburgesch
            case .ltz: return "Lëtzebuergesch"
            /// Luba-Lulua
            case .lua: return "Tshiluba"
            /// Luba-Katanga
            case .lub: return "Kiluba"
            /// Ganda
            case .lug: return "Luganda"
            /// Luiseno
            case .lui: return "Cham'teela"
            /// Lunda
            case .lun: return "Chilunda"
            /// Luo (Kenya and Tanzania)
            case .luo: return "Dholuo"
            /// Lushai
            case .lus: return "Mizo ṭawng"
            /// Macedonian
            case .mkd: return "македонски јазик"
            /// Madurese
            case .mad: return "Madhura"
            /// Magahi
            case .mag: return "मगही"
            /// Marshallese
            case .mah: return "Kajin M̧ajeļ"
            /// Maithili
            case .mai: return "मैथिली; মৈথিলী"
            /// Makasar
            case .mak: return "Basa Mangkasara' / ᨅᨔ ᨆᨀᨔᨑ"
            /// Malayalam
            case .mal: return "മലയാളം"
            /// Mandingo
            case .man: return "Mandi'nka kango"
            /// Maori
            case .mri: return "Te Reo Māori"
            /// Marathi
            case .mar: return "मराठी"
            /// Masai
            case .mas: return "ɔl"
            /// Malay
            case .msa: return "Bahasa Melayu"
            /// Moksha
            case .mdf: return "мокшень кяль"
            /// Mende
            case .men: return "Mɛnde yia"
            /// Irish, Middle (900–1200)
            case .mga: return "Gaoidhealg"
            /// Mi'kmaq; Micmac
            case .mic: return "Míkmawísimk"
            /// Minangkabau
            case .min: return "Baso Minang"
            /// Maltese
            case .mlt: return "Malti"
            /// Manchu
            case .mnc: return "ᠮᠠᠨᠵᡠ ᡤᡳᠰᡠᠨ"
            /// Mohawk
            case .moh: return "Kanien’kéha"
            /// Mongolian
            case .mon: return "монгол хэл; ᠮᠣᠩᠭᠣᠯ ᠬᠡᠯᠡ"
            /// Mossi
            case .mos: return "Mooré"
            /// Creek
            case .mus: return "Mvskoke"
            /// Mirandese
            case .mwl: return "mirandés; lhéngua mirandesa"
            /// Marwari
            case .mwr: return "मारवाड़ी"
            /// Erzya
            case .myv: return "эрзянь кель"
            /// Neapolitan
            case .nap: return "napulitano"
            /// Nauru
            case .nau: return "dorerin Naoero"
            /// Navajo; Navaho
            case .nav: return "Diné bizaad; Naabeehó bizaad"
            /// Ndebele, South; South Ndebele
            case .nbl: return "isiNdebele seSewula"
            /// Ndebele, North; North Ndebele
            case .nde: return "siNdebele saseNyakatho"
            /// Ndonga
            case .ndo: return "ndonga"
            /// Low German; Low Saxon; German, Low; Saxon, Low
            case .nds: return "Plattdütsch; Plattdüütsch"
            /// Nepali
            case .nep: return "नेपाली भाषा"
            /// Nepal Bhasa; Newari
            case .new: return "नेपाल भाषा; नेवाः भाय्"
            /// Nias
            case .nia: return "Li Niha"
            /// Niuean
            case .niu: return "ko e vagahau Niuē"
            /// Norwegian Nynorsk; Nynorsk, Norwegian
            case .nno: return "nynorsk"
            /// Bokmål, Norwegian; Norwegian Bokmål
            case .nob: return "bokmål"
            /// Nogai
            case .nog: return "Ногай тили"
            /// Norse, Old
            case .non: return "Dǫnsk tunga; Norrœnt mál"
            /// Norwegian
            case .nor: return "norsk"
            /// Pedi; Sepedi; Northern Sotho
            case .nso: return "Sesotho sa Leboa"
            /// Nubian languages
            case .nub: return "لغات نوبية"
            /// Classical Newari; Old Newari; Classical Nepal Bhasa
            case .nwc: return "पुलां भाय्; पुलाङु नेपाल भाय्"
            /// Chichewa; Chewa; Nyanja
            case .nya: return "Chichewa; Chinyanja"
            /// Nyoro
            case .nyo: return "Runyoro"
            /// Occitan (post 1500); Provençal
            case .oci: return "occitan; lenga d'òc; provençal"
            /// Oriya
            case .ori: return "ଓଡ଼ିଆ"
            /// Oromo
            case .orm: return "Afaan Oromoo"
            /// Osage
            case .osa: return "Wazhazhe ie"
            /// Ossetian; Ossetic
            case .oss: return "Ирон æвзаг"
            /// Turkish, Ottoman (1500–1928)
            case .ota: return "لسان عثمانى / lisân-ı Osmânî"
            /// Pangasinan
            case .pag: return "Salitan Pangasinan"
            /// Pahlavi
            case .pal: return "Pārsīk; Pārsīg"
            /// Pampanga; Kapampangan
            case .pam: return "Amánung Kapampangan; Amánung Sísuan"
            /// Panjabi; Punjabi
            case .pan: return "ਪੰਜਾਬੀ / پنجابی"
            /// Papiamento
            case .pap: return "Papiamentu"
            /// Palauan
            case .pau: return "a tekoi er a Belau"
            /// Phoenician
            case .phn: return "𐤃𐤁𐤓𐤉𐤌 𐤊𐤍𐤏𐤍𐤉𐤌"
            /// Pali
            case .pli: return "Pāli"
            /// Polish
            case .pol: return "Język polski"
            /// Portuguese
            case .por: return "português"
            /// Pushto; Pashto
            case .pus: return "پښتو"
            /// Quechua
            case .que: return "Runa simi; kichwa simi; Nuna shimi"
            /// Rajasthani
            case .raj: return "राजस्थानी"
            /// Rapanui
            case .rap: return "Vananga rapa nui"
            /// Rarotongan; Cook Islands Maori
            case .rar: return "Māori Kūki 'Āirani"
            /// Romansh
            case .roh: return "Rumantsch; Rumàntsch; Romauntsch; Romontsch"
            /// Romany
            case .rom: return "romani čhib"
            /// Romanian; Moldavian; Moldovan
            case .ron: return "limba română"
            /// Rundi
            case .run: return "Ikirundi"
            /// Aromanian; Arumanian; Macedo-Romanian
            case .rup: return "armãneashce; armãneashti; rrãmãneshti"
            /// Russian
            case .rus: return "русский язык"
            /// Sandawe
            case .sad: return "Sandaweeki"
            /// Sango
            case .sag: return "yângâ tî sängö"
            /// Yakut
            case .sah: return "Сахалыы"
            /// Samaritan Aramaic
            case .sam: return "ארמית"
            /// Santali
            case .sat: return "ᱥᱟᱱᱛᱟᱲᱤ"
            /// Sicilian
            case .scn: return "Sicilianu"
            /// Scots
            case .sco: return "Braid Scots; Lallans"
            /// Irish, Old (to 900)
            case .sga: return "Goídelc"
            /// Shan
            case .shn: return "ၵႂၢမ်းတႆးယႂ်"
            /// Sidamo
            case .sid: return "Sidaamu Afoo"
            /// Sinhala; Sinhalese
            case .sin: return "සිංහල"
            /// Slovak
            case .slk: return "slovenčina; slovenský jazyk"
            /// Slovenian
            case .slv: return "slovenski jezik; slovenščina"
            /// Southern Sami
            case .sma: return "Åarjelsaemien gïele"
            /// Northern Sami
            case .sme: return "davvisámegiella"
            /// Lule Sami
            case .smj: return "julevsámegiella"
            /// Inari Sami
            case .smn: return "anarâškielâ"
            /// Samoan
            case .smo: return "Gagana faʻa Sāmoa"
            /// Skolt Sami
            case .sms: return "sääʹmǩiõll"
            /// Shona
            case .sna: return "chiShona"
            /// Sindhi
            case .snd: return "سنڌي / सिन्धी / ਸਿੰਧੀ"
            /// Soninke
            case .snk: return "Sooninkanxanne"
            /// Somali
            case .som: return "af Soomaali"
            /// Sotho, Southern
            case .sot: return "Sesotho [southern]"
            /// Spanish; Castilian
            case .spa: return "español; castellano"
            /// Sardinian
            case .srd: return "sardu; limba sarda; lingua sarda"
            /// Serbian
            case .srp: return "српски / srpski"
            /// Serer
            case .srr: return "Seereer"
            /// Swati
            case .ssw: return "siSwati"
            /// Sukuma
            case .suk: return "Kɪsukuma"
            /// Sundanese
            case .sun: return "ᮘᮞ ᮞᮥᮔ᮪ᮓ / Basa Sunda"
            /// Susu
            case .sus: return "Sosoxui"
            /// Sumerian
            case .sux: return "𒅴𒂠"
            /// Swahili
            case .swa: return "Kiswahili"
            /// Swedish
            case .swe: return "svenska"
            /// Syriac
            case .syr: return "ܠܫܢܐ ܣܘܪܝܝܐ"
            /// Tahitian
            case .tah: return "Reo Tahiti; Reo Mā'ohi"
            /// Tai languages
            case .tai: return "ภาษาไท; ภาษาไต"
            /// Tamil
            case .tam: return "தமிழ்"
            /// Tatar
            case .tat: return "татар теле / tatar tele / تاتار"
            /// Telugu
            case .tel: return "తెలుగు"
            /// Timne
            case .tem: return "KʌThemnɛ"
            /// Tereno
            case .ter: return "Terêna"
            /// Tetum
            case .tet: return "Lia-Tetun"
            /// Tajik
            case .tgk: return "тоҷикӣ / tojikī"
            /// Tagalog
            case .tgl: return "Wikang Tagalog"
            /// Thai
            case .tha: return "ภาษาไทย"
            /// Tigre
            case .tig: return "ትግረ; ትግሬ; ኻሳ; ትግራይት"
            /// Tigrinya
            case .tir: return "ትግርኛ"
            /// Tlingit
            case .tli: return "Lingít"
            /// Tonga, Nyasa
            case .tog: return "chiTonga"
            /// Tonga (Tonga Islands)
            case .ton: return "lea faka-Tonga"
            /// Tswana
            case .tsn: return "Setswana"
            /// Tsonga
            case .tso: return "Xitsonga"
            /// Turkmen
            case .tuk: return "Türkmençe / Түркменче / تورکمن تیلی تورکمنچ; türkmen dili / түркмен дили"
            /// Tumbuka
            case .tum: return "chiTumbuka"
            /// Turkish
            case .tur: return "Türkçe"
            /// Tuvalu
            case .tvl: return "Te Ggana Tuuvalu; Te Gagana Tuuvalu"
            /// Tuvinian
            case .tyv: return "тыва дыл"
            /// Udmurt
            case .udm: return "удмурт кыл"
            /// Uighur; Uyghur
            case .uig: return "ئۇيغۇرچە ; ئۇيغۇر تىلى"
            /// Ukrainian
            case .ukr: return "українська мова"
            /// Umbundu
            case .umb: return "Úmbúndú"
            /// Urdu
            case .urd: return "اُردُو"
            /// Uzbek
            case .uzb: return "Oʻzbekcha / ўзбекча / ئوزبېچه; oʻzbek tili / ўзбек тили / ئوبېک تیلی"
            /// Vai
            case .vai: return "ꕙꔤ"
            /// Venda
            case .ven: return "Tshivenḓa"
            /// Vietnamese
            case .vie: return "Tiếng Việt"
            /// Votic
            case .vot: return "vađđa ceeli"
            /// Waray
            case .war: return "Winaray; Samareño; Lineyte-Samarnon; Binisayâ nga Winaray; Binisayâ nga Samar-Leyte; “Binisayâ nga Waray”"
            /// Washo
            case .was: return "wá:šiw ʔítlu"
            /// Sorbian languages
            case .wen: return "Serbsce / Serbski"
            /// Walloon
            case .wln: return "Walon"
            /// Kalmyk; Oirat
            case .xal: return "Хальмг келн / Xaľmg keln"
            /// Xhosa
            case .xho: return "isiXhosa"
            /// Yiddish
            case .yid: return "ייִדיש; יידיש; אידיש"
            /// Yoruba
            case .yor: return "èdè Yorùbá"
            /// Zapotec
            case .zap: return "Diidxazá"
            /// Zenaga
            case .zen: return "Tuḍḍungiyya"
            /// Standard Moroccan Tamazight
            case .zgh: return "ⵜⴰⵎⴰⵣⵉⵖⵜ ⵜⴰⵏⴰⵡⴰⵢⵜ"
            /// Zhuang; Chuang
            case .zha: return "Vahcuengh / 話僮"
            /// Zulu
            case .zul: return "isiZulu"
            /// Zuni
            case .zun: return "Shiwi'ma"
            default: return self.rawValue
        }
    }
    
    // MARK: Bibliographic Code
    public var isoBibliographicCode: String {
        switch self {
            /// Albanian
            case .sqi: return "alb"
            /// Armenian
            case .hye: return "arm"
            /// Basque
            case .eus: return "baq"
            /// Tibetan
            case .bod: return "tib"
            /// Burmese
            case .mya: return "bur"
            /// Czech
            case .ces: return "cze"
            /// Chinese
            case .zho: return "chi"
            /// Welsh
            case .cym: return "wel"
            /// German
            case .deu: return "ger"
            /// Dutch; Flemish
            case .nld: return "dut"
            /// Greek, Modern (1453–)
            case .ell: return "gre"
            /// Persian
            case .fas: return "per"
            /// French
            case .fra: return "fre"
            /// Georgian
            case .kat: return "geo"
            /// Icelandic
            case .isl: return "ice"
            /// Macedonian
            case .mkd: return "mac"
            /// Maori
            case .mri: return "mao"
            /// Malay
            case .msa: return "may"
            /// Romanian; Moldavian; Moldovan
            case .ron: return "rum"
            /// Slovak
            case .slk: return "slo"
            default: break
        }; return self.rawValue
    }
    
    // MARK: Mappings
    public static let isoNameToNativeNameMapping: [String: String] = {
        var mapping: [String: String] = [:]
        for name in ISO6392Codes.allCases {
            let isoName = name.rawValue
            mapping[isoName] = name.nativeName
        }
        return mapping
    }()
    
    public static let nativeNameToIsoNameMapping: [String: String] = {
        var mapping: [String: String] = [:]
        for name in ISO6392Codes.allCases {
            let nativeName = name.nativeName
            mapping[nativeName] = name.rawValue
        }
        return mapping
    }()
    
    public static let nativeNameToIsoCode: [String: ISO6392Codes] = {
        var mapping: [String: ISO6392Codes] = [:]
        for code in ISO6392Codes.allCases {
            let nativeName = code.nativeName
            mapping[nativeName] = code
        }
        return mapping
    }()
}
