import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twin_finder/api/models/user_profile_response.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/core/utils/geolocation_service.dart';
import 'package:twin_finder/core/utils/registration_step_service.dart';

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

class LocationPage extends StatefulWidget {
  final UserProfileResponse? profileData;

  const LocationPage({super.key, this.profileData});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _dio = Dio(
    BaseOptions(
      headers: {'User-Agent': 'TwinFinder/1.0 (contact: you@example.com)'},
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );

  // controllers / focus
  final _countryCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _countryFocus = FocusNode();
  final _cityFocus = FocusNode();

  // debounce
  Timer? _debounce;

  // state
  bool _loadingCountry = false;
  bool _loadingCity = false;
  List<Country> _countrySuggestions = [];
  List<City> _citySuggestions = [];
  Country? _selectedCountry;
  City? _selectedCity;

  @override
  void initState() {
    super.initState();

    // Pre-fill country and city if available from profile data
    if (widget.profileData != null) {
      if (widget.profileData!.data.country != null) {
        final countryName = widget.profileData!.data.country!;
        _countryCtrl.text = countryName;
        // Create selected country object immediately with temporary code
        // The real code will be updated when _getCountryCodeFromName returns
        _selectedCountry = Country(name: countryName, code: 'XX');
        // Get the proper country code via API
        _getCountryCodeFromName(countryName);
      }
      if (widget.profileData!.data.city != null) {
        final cityName = widget.profileData!.data.city!;
        _cityCtrl.text = cityName;
        // Create selected city object immediately
        _selectedCity = City(
          name: cityName,
          country: _selectedCountry?.name ?? '',
          countryCode: _selectedCountry?.code ?? 'XX',
          lat: 0.0,
          lon: 0.0,
        );
      }
    }

    _countryFocus.addListener(() => setState(() {}));
    _cityFocus.addListener(() => setState(() {}));

    // Автоматически определяем страну и город по геолокации с небольшой задержкой
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _autoDetectLocation();
      }
    });
    _countryCtrl.addListener(() {
      // если пользователь меняет текст вручную — сбросим выбранную страну и города
      if (_selectedCountry != null &&
          _countryCtrl.text != _selectedCountry!.name) {
        setState(() {
          _selectedCountry = null;
          _cityCtrl.clear();
          _citySuggestions = [];
          _selectedCity = null;
        });
      }
    });
    _cityCtrl.addListener(() {
      if (_selectedCity != null && _cityCtrl.text != _selectedCity!.name) {
        setState(() => _selectedCity = null);
      }
    });
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

  /// Автоматически определяет страну и город по геолокации
  Future<void> _autoDetectLocation() async {
    // Проверяем, есть ли уже данные из профиля
    if (widget.profileData?.data.country != null ||
        widget.profileData?.data.city != null) {
      return; // Не перезаписываем существующие данные
    }

    try {
      // Добавляем небольшую задержку для стабилизации UI
      await Future.delayed(const Duration(milliseconds: 500));

      // Показываем индикатор загрузки
      if (mounted) {
        setState(() {
          _loadingCountry = true;
          _loadingCity = true;
        });
      }

      // Получаем страну и город по геолокации
      final locationData = await GeolocationService.getCurrentCountryAndCity();
      print(locationData);
      if (mounted) {
        setState(() {
          if (locationData['country'] != null) {
            _countryCtrl.text = locationData['country']!;
            _selectedCountry = Country(
              name: locationData['country']!,
              code: 'XX',
            );
            _getCountryCodeFromName(locationData['country']!);
          }

          if (locationData['city'] != null) {
            _cityCtrl.text = locationData['city']!;
            _selectedCity = City(
              name: locationData['city']!,
              country: locationData['country'] ?? '',
              countryCode: 'XX',
              lat: 0.0,
              lon: 0.0,
            );
          }
        });
      }
    } catch (e) {
      print(e);
      // Ошибка геолокации - ничего не делаем, пользователь может ввести вручную
    } finally {
      if (mounted) {
        setState(() {
          _loadingCountry = false;
          _loadingCity = false;
        });
      }
    }
  }

  // ===== APIs =====

  Future<void> _getCountryCodeFromName(String countryName) async {
    try {
      final res = await _dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': countryName,
          'count': 1,
          'language': 'en',
          'format': 'json',
        },
      );

      final list = (res.data?['results'] as List?) ?? [];
      if (list.isNotEmpty) {
        final countryData = list.first;
        final countryCode = countryData['country_code'] as String?;
        if (countryCode != null &&
            countryCode.isNotEmpty &&
            countryCode != 'XX') {
          setState(() {
            _selectedCountry = Country(name: countryName, code: countryCode);
            // Update city's country code if city is already selected
            if (_selectedCity != null) {
              _selectedCity = City(
                name: _selectedCity!.name,
                country: countryName,
                countryCode: countryCode,
                lat: _selectedCity!.lat,
                lon: _selectedCity!.lon,
                admin1: _selectedCity!.admin1,
              );
            }
          });
          // После получения country code, запускаем поиск городов только если город не выбран
          if (_selectedCity == null) {
            _debounced(() => _searchCities(''));
          }
        } else {
          debugPrint('Invalid country code received: $countryCode');
        }
      } else {
        debugPrint('No results found for country: $countryName');
      }
    } catch (e) {
      debugPrint('Error getting country code: $e');
    }
  }

  Future<void> _searchCountries(String query) async {
    query = query.trim();
    if (query.isEmpty) {
      setState(() => _countrySuggestions = []);
      return;
    }
    setState(() => _loadingCountry = true);
    try {
      final res = await _dio.get(
        'https://restcountries.com/v3.1/name/${Uri.encodeComponent(query)}',
        queryParameters: {'fields': 'name,cca2'},
      );
      final list = (res.data as List?) ?? [];
      final out = list
          .map<Country>((e) {
            final n = e['name']?['common'] as String? ?? '';
            final c = e['cca2'] as String? ?? '';
            return Country(name: n, code: c);
          })
          .where((e) => e.name.isNotEmpty && e.code.isNotEmpty)
          .toList();

      setState(() => _countrySuggestions = out.take(10).toList());
    } catch (_) {
      setState(() => _countrySuggestions = []);
    } finally {
      setState(() => _loadingCountry = false);
    }
  }

  Future<void> _searchCities(String query) async {
    query = query.trim();
    final country = _selectedCountry;
    if (country == null) {
      setState(() => _citySuggestions = []);
      return;
    }

    // Проверяем, что у нас есть правильный country code (не 'XX')
    if (country.code == 'XX' || country.code.isEmpty) {
      debugPrint('Waiting for proper country code...');
      setState(() => _citySuggestions = []);
      return;
    }

    // Если запрос пустой, показываем популярные города для выбранной страны
    if (query.isEmpty) {
      query = country.name; // Используем название страны как базовый запрос
    }
    const minCityPopulation = 50000;

    setState(() => _loadingCity = true);
    try {
      final res = await _dio.get(
        'https://geocoding-api.open-meteo.com/v1/search',
        queryParameters: {
          'name': query,
          'count': 20,
          'language': 'en',
          'format': 'json',
          'countryCode': country.code.toUpperCase(),
        },
      );

      final list = (res.data?['results'] as List?) ?? [];
      final filtered =
          list.where((e) {
            final code = (e['feature_code'] ?? '').toString();
            final pop = (e['population'] as num?)?.toInt() ?? 0;

            final isCapitalOrAdmin =
                code == 'PPLC' ||
                code == 'PPLA' ||
                code == 'PPLA2' ||
                code == 'PPLA3' ||
                code == 'PPLA4';
            final isCityByPop =
                code.startsWith('PPL') && pop >= minCityPopulation;

            return isCapitalOrAdmin || isCityByPop;
          }).toList()..sort((a, b) {
            final pa = (a['population'] as num?)?.toInt() ?? 0;
            final pb = (b['population'] as num?)?.toInt() ?? 0;
            return pb.compareTo(pa);
          });

      setState(() {
        _citySuggestions = filtered.map((e) => City.fromJson(e)).toList();
      });
    } catch (e) {
      debugPrint('Error searching cities: $e');
      setState(() => _citySuggestions = []);
    } finally {
      setState(() => _loadingCity = false);
    }
  }
  // ===== UI helpers =====

  double _listHeightFor(int count, {int maxItems = 4}) {
    if (count == 0) return 0;
    final shown = count < maxItems ? count : maxItems;
    return (56.0 * shown) + 20.0 - 1.0; // как в твоём расчёте
  }

  InputDecoration _decor() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      hintText: '',
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
            child: Text(
              text,
              style: TextStyle(
                // fontSize: active ? 12 : 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Bricolage Grotesque',
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectCountry(Country c) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCountry = c;
      _countryCtrl.text = c.name;
      _countrySuggestions = [];
      // Очищаем город при смене страны
      _cityCtrl.clear();
      _citySuggestions = [];
      _selectedCity = null;
    });
    _countryFocus.unfocus();

    // Автоматически запускаем поиск городов для выбранной страны
    // Только если у страны есть правильный код (не 'XX')
    if (c.name.isNotEmpty && c.code != 'XX' && c.code.isNotEmpty) {
      _debounced(() => _searchCities(''));
    }
  }

  void _selectCity(City c) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedCity = c;
      _cityCtrl.text = c.name;
      _citySuggestions = [];
    });
    _cityFocus.unfocus();
  }

  bool get _canContinue => _selectedCountry != null && _selectedCity != null;

  /// Normalize city name by removing district numbers and extra text
  /// Examples: "Dublin 7" → "Dublin", "New York (Manhattan)" → "New York"
  String _normalizeCityName(String cityName) {
    // Remove district numbers (e.g., "Dublin 7" → "Dublin")
    final withoutNumbers = cityName.replaceAll(RegExp(r'\s+\d+$'), '');

    // Remove parenthetical text (e.g., "Paris (Île-de-France)" → "Paris")
    final withoutParens = withoutNumbers.replaceAll(RegExp(r'\s*\([^)]*\)'), '');

    return withoutParens.trim();
  }

  @override
  Widget build(BuildContext context) {
    final countryActive =
        _countryFocus.hasFocus || _countryCtrl.text.isNotEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BackgroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Back
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: SvgPicture.asset(AppIcons.back, color: Colors.white),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Use animated route for back navigation
                    context.onlyAnimatedRoute(
                      AppRoutes.gender,
                      arguments: [widget.profileData],
                    );
                  },
                ),
              ),
              // Title
              SizedBox(height: 16),
              // title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  L.whereAreYouFrom(context),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1,
                    letterSpacing: -0.48,
                    fontFamily: 'Bricolage Grotesque',
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Stack(
                children: [
                  AnimatedContainer(
                    height: _countryFocus.hasFocus
                        ? _listHeightFor(_countrySuggestions.length)
                        : 0,
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ).copyWith(top: 40),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: _countrySuggestions.length,
                      itemBuilder: (context, i) {
                        final c = _countrySuggestions[i];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                c.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily: 'Bricolage Grotesque',
                                ),
                              ),
                              onTap: () => _selectCountry(c),
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
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              cursorHeight: 16,
                              cursorColor: AppColors.backgroundTop,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (v) {
                                // Сбрасываем выбранную страну при изменении текста
                                if (_selectedCountry != null &&
                                    _selectedCountry!.name != v) {
                                  setState(() {
                                    _selectedCountry = null;
                                    _selectedCity = null;
                                    _cityCtrl.clear();
                                    _citySuggestions = [];
                                  });
                                }
                                _debounced(() => _searchCountries(v));
                              },
                              decoration: _decor().copyWith(
                                suffixIcon: _loadingCountry
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.backgroundBottom,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'Bricolage Grotesque',
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

              Stack(
                children: [
                  AnimatedContainer(
                    height: _cityFocus.hasFocus
                        ? _listHeightFor(_citySuggestions.length)
                        : 0,
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ).copyWith(top: 40),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(246, 246, 246, 1),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      itemCount: _citySuggestions.length,
                      itemBuilder: (context, i) {
                        final c = _citySuggestions[i];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                c.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily: 'Bricolage Grotesque',
                                ),
                              ),
                              // subtitle: Text(subtitle),
                              onTap: () => _selectCity(c),
                            ),
                            if (i < _citySuggestions.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Divider(height: 1),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 56,
                    decoration: BoxDecoration(
                      color: _selectedCountry == null
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextField(
                              controller: _cityCtrl,
                              focusNode: _cityFocus,
                              enabled: _selectedCountry != null,
                              cursorHeight: 16,
                              cursorColor: AppColors.backgroundTop,
                              textCapitalization: TextCapitalization.words,
                              onChanged: (v) {
                                // Сбрасываем выбранный город при изменении текста
                                if (_selectedCity != null &&
                                    _selectedCity!.name != v) {
                                  setState(() {
                                    _selectedCity = null;
                                  });
                                }
                                _debounced(() => _searchCities(v));
                              },
                              decoration: _selectedCountry == null
                                  ? null
                                  : _decor().copyWith(
                                      suffixIcon: _loadingCity
                                          ? const Padding(
                                              padding: EdgeInsets.all(12),
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 1.5,
                                                    ),
                                              ),
                                            )
                                          : null,
                                    ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'Bricolage Grotesque',
                              ),
                            ),
                          ),
                        ),
                        _floatingLabel(
                          'City',
                          true ==
                              (_cityFocus.hasFocus ||
                                  _cityCtrl.text.isNotEmpty),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Spacer(),
              // Continue
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Center(
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      // Handle error states in listener (runs only once per state change)
                      if (state is AuthProfileUpdateFailed) {
                        ErrorHandler.showError(
                          context,
                          '${L.error(context)}: ${state.message}',
                          title: L.error(context),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;

                      return GestureDetector(
                        onTap: _canContinue && !isLoading
                            ? () async {
                                HapticFeedback.lightImpact();

                                // Update location in AuthCubit
                                final authCubit = context.read<AuthCubit>();
                                // Normalize city name to remove district numbers/extra text
                                final normalizedCity = _normalizeCityName(_selectedCity!.name);
                                await authCubit.updateProfile(
                                  country: _selectedCountry!.name,
                                  city: normalizedCity,
                                );

                                // Check if update was successful and navigate
                                if (mounted) {
                                  final currentState = authCubit.state;
                                  if (currentState is AuthAuthenticated ||
                                      currentState
                                          is AuthNeedsProfileSetupWithData) {
                                    debugPrint(
                                      'Location updated successfully, navigating to face capture page',
                                    );

                                    // Save next step before navigating
                                    await RegistrationStepService.saveStep(
                                      RegistrationStepService.stepPhoto,
                                    );

                                    if (!mounted) return;

                                    context.onlyAnimatedRoute(
                                      AppRoutes.faceCapturePage,
                                    );
                                    debugPrint(
                                      'Navigation to face capture page initiated',
                                    );
                                  }
                                }
                              }
                            : null,
                        child: Container(
                          height: 56,
                          width: 216,
                          decoration: BoxDecoration(
                            color: _canContinue && !isLoading
                                ? AppColors.button
                                : AppColors.button.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    L.continue_(context),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: _canContinue && !isLoading
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                      fontFamily: 'Bricolage Grotesque',
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
