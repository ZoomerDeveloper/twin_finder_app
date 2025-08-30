import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Country {
  final String name; // "Montenegro"
  final String code; // ISO2: "ME"
  const Country({required this.name, required this.code});
}

class City {
  final String name;
  final String country;
  final String countryCode;
  final String? admin1;
  final double lat;
  final double lon;

  City({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.lat,
    required this.lon,
    this.admin1,
  });

  factory City.fromJson(Map<String, dynamic> j) => City(
    name: j['name'],
    country: j['country'],
    countryCode: j['country_code'],
    lat: (j['latitude'] as num).toDouble(),
    lon: (j['longitude'] as num).toDouble(),
    admin1: j['admin1'],
  );
}

class CountryCityInline extends StatefulWidget {
  final void Function(Country country, City city)? onSelected;

  /// Если указать, страна будет предустановлена
  final Country? fixedCountry;

  /// Если true – поле "Страна" readOnly, без подсказок
  final bool lockCountry;

  const CountryCityInline({
    super.key,
    this.onSelected,
    this.fixedCountry,
    this.lockCountry = false,
  });

  @override
  State<CountryCityInline> createState() => _CountryCityInlineState();
}

class _CountryCityInlineState extends State<CountryCityInline> {
  final _dio = Dio(
    BaseOptions(
      headers: {'User-Agent': 'TwinFinder/1.0 (contact: you@example.com)'},
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );

  final _countryCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryFocus = FocusNode();
  final _cityFocus = FocusNode();

  Timer? _debounce;
  bool _loadingCountry = false;
  bool _loadingCity = false;

  List<Country> _countrySuggestions = [];
  List<City> _citySuggestions = [];

  Country? _selectedCountry;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();

    // если передана фиксированная страна — проставим её и заполним поле
    if (widget.fixedCountry != null) {
      _selectedCountry = widget.fixedCountry;
      _countryCtrl.text = widget.fixedCountry!.name;
    }

    // слушатели фокуса/текста — опционально, как у тебя
  }

  @override
  void dispose() {
    _countryCtrl.dispose();
    _cityCtrl.dispose();
    _countryFocus.dispose();
    _cityFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _debounced(void Function() action) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), action);
  }

  // === API ===

  Future<void> _searchCountries(String query) async {
    if (widget.lockCountry) {
      setState(() => _countrySuggestions = []);
      return;
    }
    // ... прежняя реализация поиска стран ...
  }

  // --- города: всегда фильтруем по выбранной/фиксированной стране ---
  Future<void> _searchCities(String query) async {
    final country = _selectedCountry ?? widget.fixedCountry;
    if (country == null || query.trim().isEmpty) {
      setState(() => _citySuggestions = []);
      return;
    }
    setState(() => _loadingCity = true);
    try {
      final res = await _dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': query,
          'count': 10,
          'language': 'ru',
          'format': 'json',
          'country_code': country.code, // ← фиксируем ISO страны
        },
      );
      final list = (res.data?['results'] as List?) ?? [];
      setState(
        () => _citySuggestions = list.map((e) => City.fromJson(e)).toList(),
      );
    } finally {
      setState(() => _loadingCity = false);
    }
  }

  // === UI helpers ===

  double _listHeightFor(int count, {int max = 4}) {
    if (count == 0) return 0;
    final shown = count < max ? count : max;
    return (56.0 * shown) + 20.0 - 1.0; // как у тебя
  }

  InputDecoration _decor(String label, {Widget? suffix}) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      hintText: '',
      suffixIcon: suffix,
      // кастомный “плавающий” лейбл поверх, без стандартного labelText
    );
  }

  Widget _floatingLabel(String text, bool active) {
    return IgnorePointer(
      ignoring: true,
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 180),
        alignment: active ? Alignment.topLeft : Alignment.centerLeft,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.only(left: 16, top: active ? 8 : 0),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(
              fontSize: active ? 12 : 20,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryActive =
        _countryFocus.hasFocus || _countryCtrl.text.isNotEmpty;
    final cityActive = _cityFocus.hasFocus || _cityCtrl.text.isNotEmpty;

    return Column(
      children: [
        // ===== Страна =====
        Stack(
          children: [
            // если страна залочена — вообще не показываем дропдаун
            if (!widget.lockCountry)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _countryFocus.hasFocus
                    ? _listHeightFor(_countrySuggestions.length)
                    : 0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ).copyWith(top: 40),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFEF),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: _countrySuggestions.length,
                  itemBuilder: (_, i) {
                    final c = _countrySuggestions[i];
                    return Column(
                      children: [
                        ListTile(
                          title: Text('${c.name} (${c.code})'),
                          onTap: () {
                            setState(() {
                              _selectedCountry = c;
                              _countryCtrl.text = c.name;
                              _countrySuggestions = [];
                              _cityCtrl.clear();
                              _citySuggestions = [];
                              _selectedCity = null;
                            });
                            _countryFocus.unfocus();
                          },
                        ),
                        if (i < _countrySuggestions.length - 1)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(height: 1),
                          ),
                      ],
                    );
                  },
                ),
              ),

            // поле "Страна"
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(widget.lockCountry ? 0.9 : 1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextField(
                        controller: _countryCtrl,
                        focusNode: _countryFocus,
                        readOnly:
                            widget.lockCountry, // ← делаем нередактируемым
                        onChanged: (v) => _debounced(() => _searchCountries(v)),
                        decoration: _decor(
                          'Country',
                          suffix: _loadingCountry && !widget.lockCountry
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  _floatingLabel('Country', countryActive),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ===== Город ===== (без изменений, ищет в рамках зафиксированной страны)
        // ... твой прежний блок города с дропдауном ...
      ],
    );
  }
}
