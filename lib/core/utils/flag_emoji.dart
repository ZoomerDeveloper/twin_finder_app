/// Утилита для работы с эмодзи флагами стран
class FlagEmoji {
  /// Возвращает эмодзи флага страны на основе названия страны
  static String getCountryFlag(String? countryName) {
    if (countryName == null || countryName.isEmpty) return '🌍';

    // Простое сопоставление названий стран с эмодзи флагами
    final country = countryName.toLowerCase();

    switch (country) {
      // Северная Америка
      case 'united states':
      case 'usa':
      case 'us':
      case 'united states of america':
        return '🇺🇸';
      case 'canada':
        return '🇨🇦';
      case 'mexico':
      case 'méxico':
        return '🇲🇽';
      case 'cuba':
        return '🇨🇺';
      case 'jamaica':
        return '🇯🇲';
      case 'haiti':
        return '🇭🇹';
      case 'dominican republic':
        return '🇩🇴';
      case 'puerto rico':
        return '🇵🇷';
      case 'trinidad and tobago':
        return '🇹🇹';
      case 'barbados':
        return '🇧🇧';
      case 'bahamas':
        return '🇧🇸';
      case 'panama':
        return '🇵🇦';
      case 'costa rica':
        return '🇨🇷';
      case 'nicaragua':
        return '🇳🇮';
      case 'honduras':
        return '🇭🇳';
      case 'el salvador':
        return '🇸🇻';
      case 'guatemala':
        return '🇬🇹';
      case 'belize':
        return '🇧🇿';

      // Южная Америка
      case 'brazil':
      case 'brasil':
        return '🇧🇷';
      case 'argentina':
        return '🇦🇷';
      case 'chile':
        return '🇨🇱';
      case 'colombia':
        return '🇨🇴';
      case 'peru':
        return '🇵🇪';
      case 'venezuela':
        return '🇻🇪';
      case 'ecuador':
        return '🇪🇨';
      case 'bolivia':
        return '🇧🇴';
      case 'paraguay':
        return '🇵🇾';
      case 'uruguay':
        return '🇺🇾';
      case 'guyana':
        return '🇬🇾';
      case 'suriname':
        return '🇸🇷';
      case 'french guiana':
        return '🇬🇫';

      // Европа
      case 'russia':
      case 'russian federation':
        return '🇷🇺';
      case 'germany':
      case 'deutschland':
        return '🇩🇪';
      case 'france':
        return '🇫🇷';
      case 'united kingdom':
      case 'uk':
      case 'great britain':
      case 'england':
        return '🇬🇧';
      case 'italy':
      case 'italia':
        return '🇮🇹';
      case 'spain':
      case 'españa':
        return '🇪🇸';
      case 'ukraine':
        return '🇺🇦';
      case 'poland':
        return '🇵🇱';
      case 'romania':
        return '🇷🇴';
      case 'netherlands':
      case 'holland':
        return '🇳🇱';
      case 'belgium':
        return '🇧🇪';
      case 'greece':
        return '🇬🇷';
      case 'czech republic':
      case 'czechia':
        return '🇨🇿';
      case 'portugal':
        return '🇵🇹';
      case 'sweden':
        return '🇸🇪';
      case 'hungary':
        return '🇭🇺';
      case 'austria':
        return '🇦🇹';
      case 'switzerland':
      case 'schweiz':
        return '🇨🇭';
      case 'bulgaria':
        return '🇧🇬';
      case 'denmark':
        return '🇩🇰';
      case 'finland':
        return '🇫🇮';
      case 'slovakia':
        return '🇸🇰';
      case 'norway':
        return '🇳🇴';
      case 'ireland':
        return '🇮🇪';
      case 'croatia':
        return '🇭🇷';
      case 'moldova':
        return '🇲🇩';
      case 'bosnia and herzegovina':
        return '🇧🇦';
      case 'albania':
        return '🇦🇱';
      case 'lithuania':
        return '🇱🇹';
      case 'macedonia':
      case 'north macedonia':
        return '🇲🇰';
      case 'slovenia':
        return '🇸🇮';
      case 'latvia':
        return '🇱🇻';
      case 'estonia':
        return '🇪🇪';
      case 'montenegro':
        return '🇲🇪';
      case 'luxembourg':
        return '🇱🇺';
      case 'malta':
        return '🇲🇹';
      case 'iceland':
        return '🇮🇸';
      case 'cyprus':
        return '🇨🇾';
      case 'andorra':
        return '🇦🇩';
      case 'monaco':
        return '🇲🇨';
      case 'liechtenstein':
        return '🇱🇮';
      case 'san marino':
        return '🇸🇲';
      case 'vatican city':
        return '🇻🇦';

      // Азия
      case 'china':
      case 'china, people\'s republic of':
        return '🇨🇳';
      case 'japan':
      case 'japan, state of':
        return '🇯🇵';
      case 'south korea':
      case 'korea, republic of':
        return '🇰🇷';
      case 'india':
        return '🇮🇳';
      case 'indonesia':
        return '🇮🇩';
      case 'pakistan':
        return '🇵🇰';
      case 'bangladesh':
        return '🇧🇩';
      case 'thailand':
        return '🇹🇭';
      case 'vietnam':
        return '🇻🇳';
      case 'philippines':
        return '🇵🇭';
      case 'turkey':
      case 'türkiye':
        return '🇹🇷';
      case 'iran':
        return '🇮🇷';
      case 'iraq':
        return '🇮🇶';
      case 'afghanistan':
        return '🇦🇫';
      case 'saudi arabia':
        return '🇸🇦';
      case 'yemen':
        return '🇾🇪';
      case 'syria':
        return '🇸🇾';
      case 'jordan':
        return '🇯🇴';
      case 'lebanon':
        return '🇱🇧';
      case 'israel':
        return '🇮🇱';
      case 'palestine':
        return '🇵🇸';
      case 'kuwait':
        return '🇰🇼';
      case 'qatar':
        return '🇶🇦';
      case 'bahrain':
        return '🇧🇭';
      case 'oman':
        return '🇴🇲';
      case 'united arab emirates':
      case 'uae':
        return '🇦🇪';
      case 'kazakhstan':
        return '🇰🇿';
      case 'uzbekistan':
        return '🇺🇿';
      case 'turkmenistan':
        return '🇹🇲';
      case 'kyrgyzstan':
        return '🇰🇬';
      case 'tajikistan':
        return '🇹🇯';
      case 'mongolia':
        return '🇲🇳';
      case 'nepal':
        return '🇳🇵';
      case 'bhutan':
        return '🇧🇹';
      case 'sri lanka':
        return '🇱🇰';
      case 'maldives':
        return '🇲🇻';
      case 'myanmar':
      case 'burma':
        return '🇲🇲';
      case 'laos':
        return '🇱🇦';
      case 'cambodia':
        return '🇰🇭';
      case 'malaysia':
        return '🇲🇾';
      case 'singapore':
        return '🇸🇬';
      case 'brunei':
        return '🇧🇳';
      case 'east timor':
      case 'timor-leste':
        return '🇹🇱';
      case 'taiwan':
        return '🇹🇼';
      case 'hong kong':
        return '🇭🇰';
      case 'macau':
        return '🇲🇴';
      case 'north korea':
      case 'korea, democratic people\'s republic of':
        return '🇰🇵';

      // Африка
      case 'nigeria':
        return '🇳🇬';
      case 'ethiopia':
        return '🇪🇹';
      case 'egypt':
        return '🇪🇬';
      case 'democratic republic of the congo':
      case 'drc':
        return '🇨🇩';
      case 'tanzania':
        return '🇹🇿';
      case 'south africa':
        return '🇿🇦';
      case 'kenya':
        return '🇰🇪';
      case 'uganda':
        return '🇺🇬';
      case 'sudan':
        return '🇸🇩';
      case 'morocco':
        return '🇲🇦';
      case 'algeria':
        return '🇩🇿';
      case 'angola':
        return '🇦🇴';
      case 'ghana':
        return '🇬🇭';
      case 'madagascar':
        return '🇲🇬';
      case 'mozambique':
        return '🇲🇿';
      case 'cameroon':
        return '🇨🇲';
      case 'ivory coast':
      case 'côte d\'ivoire':
        return '🇨🇮';
      case 'niger':
        return '🇳🇪';
      case 'mali':
        return '🇲🇱';
      case 'burkina faso':
        return '🇧🇫';
      case 'chad':
        return '🇹🇩';
      case 'somalia':
        return '🇸🇴';
      case 'central african republic':
        return '🇨🇫';
      case 'south sudan':
        return '🇸🇸';
      case 'zimbabwe':
        return '🇿🇼';
      case 'zambia':
        return '🇿🇲';
      case 'malawi':
        return '🇲🇼';
      case 'senegal':
        return '🇸🇳';
      case 'guinea':
        return '🇬🇳';
      case 'rwanda':
        return '🇷🇼';
      case 'benin':
        return '🇧🇯';
      case 'burundi':
        return '🇧🇮';
      case 'tunisia':
        return '🇹🇳';
      case 'libya':
        return '🇱🇾';
      case 'gambia':
        return '🇬🇲';
      case 'guinea-bissau':
        return '🇬🇼';
      case 'liberia':
        return '🇱🇷';
      case 'sierra leone':
        return '🇸🇱';
      case 'togo':
        return '🇹🇬';
      case 'mauritania':
        return '🇲🇷';
      case 'namibia':
        return '🇳🇦';
      case 'botswana':
        return '🇧🇼';
      case 'lesotho':
        return '🇱🇸';
      case 'eswatini':
      case 'swaziland':
        return '🇸🇿';
      case 'comoros':
        return '🇰🇲';
      case 'mauritius':
        return '🇲🇺';
      case 'seychelles':
        return '🇸🇨';
      case 'cape verde':
        return '🇨🇻';
      case 'são tomé and príncipe':
        return '🇸🇹';
      case 'equatorial guinea':
        return '🇬🇶';
      case 'gabon':
        return '🇬🇦';
      case 'congo':
        return '🇨🇬';
      case 'djibouti':
        return '🇩🇯';
      case 'eritrea':
        return '🇪🇷';

      // Океания
      case 'australia':
        return '🇦🇺';
      case 'new zealand':
        return '🇳🇿';
      case 'papua new guinea':
        return '🇵🇬';
      case 'fiji':
        return '🇫🇯';
      case 'solomon islands':
        return '🇸🇧';
      case 'vanuatu':
        return '🇻🇺';
      case 'new caledonia':
        return '🇳🇨';
      case 'french polynesia':
        return '🇵🇫';
      case 'samoa':
        return '🇼🇸';
      case 'tonga':
        return '🇹🇴';
      case 'micronesia':
        return '🇫🇲';
      case 'palau':
        return '🇵🇼';
      case 'marshall islands':
        return '🇲🇭';
      case 'kiribati':
        return '🇰🇮';
      case 'tuvalu':
        return '🇹🇻';
      case 'nauru':
        return '🇳🇷';

      // Карибский бассейн
      case 'jamaica':
        return '🇯🇲';
      case 'haiti':
        return '🇭🇹';
      case 'dominican republic':
        return '🇩🇴';
      case 'puerto rico':
        return '🇵🇷';
      case 'trinidad and tobago':
        return '🇹🇹';
      case 'barbados':
        return '🇧🇧';
      case 'bahamas':
        return '🇧🇸';
      case 'antigua and barbuda':
        return '🇦🇬';
      case 'saint kitts and nevis':
        return '🇰🇳';
      case 'dominica':
        return '🇩🇲';
      case 'saint lucia':
        return '🇱🇨';
      case 'saint vincent and the grenadines':
        return '🇻🇨';
      case 'grenada':
        return '🇬🇩';

      default:
        return '🌍';
    }
  }
}
