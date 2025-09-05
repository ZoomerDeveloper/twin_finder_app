import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/core/utils/error_handler.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_formaters.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ChangeProfileDetailsPage extends StatefulWidget {
  const ChangeProfileDetailsPage({super.key});

  @override
  State<ChangeProfileDetailsPage> createState() =>
      _ChangeProfileDetailsPageState();
}

class _ChangeProfileDetailsPageState extends State<ChangeProfileDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();

  // Focus nodes for floating label animation
  final _nameFocus = FocusNode();
  final _countryFocus = FocusNode();
  final _cityFocus = FocusNode();

  DateTime? _selectedDate;
  String? _selectedGender;
  DateTime? _originalBirthday; // Оригинальная дата для сравнения

  bool _isLoading = false;

  // Country and city search
  final _dio = Dio(
    BaseOptions(
      headers: {'User-Agent': 'TwinFinder/1.0 (contact: you@example.com)'},
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );
  Timer? _debounce;
  bool _loadingCountry = false;
  bool _loadingCity = false;
  List<Country> _countrySuggestions = [];
  List<City> _citySuggestions = [];
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }

  void _loadCurrentProfile() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final profile = authState.me.data;
      _nameController.text = profile.name;
      _selectedDate = profile.birthday;
      _selectedGender = profile.gender;
      _countryController.text = profile.country ?? '';
      _cityController.text = profile.city ?? '';

      // Set selected country and city objects
      if (profile.country != null) {
        _selectedCountry = Country(name: profile.country!, code: 'XX');
      }
      // City will be handled by text controller

      // Сохраняем оригинальную дату для сравнения
      _originalBirthday = profile.birthday;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _nameFocus.dispose();
    _countryFocus.dispose();
    _cityFocus.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedGender == null) {
      if (mounted) {
        ErrorHandler.showError(
          context,
          L.error(context),
          title: L.error(context),
        );
      }
      return;
    }

    // Проверяем минимальный возраст только если дата была изменена
    if (_selectedDate != _originalBirthday &&
        !isMinimumAgeReached(_selectedDate!)) {
      if (mounted) {
        ErrorHandler.showError(
          context,
          L.ageRequirement(context),
          title: L.error(context),
        );
      }
      return;
    }

    // Проверяем, что если выбрана страна, то выбран и город
    if (_countryController.text.trim().isNotEmpty &&
        _cityController.text.trim().isEmpty) {
      if (mounted) {
        ErrorHandler.showError(
          context,
          L.pleaseSelectCity(context),
          title: L.error(context),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Update profile through AuthCubit
      await context.read<AuthCubit>().updateProfile(
        name: _nameController.text.trim(),
        birthday: _selectedDate!,
        gender: _selectedGender!,
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
      );

      // BlocListener will handle success/error states
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ErrorHandler.showError(
          context,
          '${L.error(context)}: $e',
          title: L.error(context),
        );
      }
    }
  }

  // Country and city search methods
  void _debounced(VoidCallback callback) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), callback);
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

      final result = out.take(10).toList();

      setState(() {
        _countrySuggestions = result;
      });
    } catch (e) {
      // Fallback to local search if API fails
      _searchCountriesLocal(query);
    } finally {
      setState(() => _loadingCountry = false);
    }
  }

  void _searchCountriesLocal(String query) {
    // Common countries list as fallback
    final commonCountries = [
      'United States',
      'Canada',
      'United Kingdom',
      'Germany',
      'France',
      'Italy',
      'Spain',
      'Netherlands',
      'Belgium',
      'Switzerland',
      'Austria',
      'Sweden',
      'Norway',
      'Denmark',
      'Finland',
      'Poland',
      'Czech Republic',
      'Hungary',
      'Slovakia',
      'Slovenia',
      'Croatia',
      'Serbia',
      'Bosnia and Herzegovina',
      'Montenegro',
      'Albania',
      'Greece',
      'Bulgaria',
      'Romania',
      'Moldova',
      'Ukraine',
      'Belarus',
      'Lithuania',
      'Latvia',
      'Estonia',
      'Russia',
      'Turkey',
      'Georgia',
      'Armenia',
      'Azerbaijan',
      'Kazakhstan',
      'Uzbekistan',
      'Turkmenistan',
      'Kyrgyzstan',
      'Tajikistan',
      'Afghanistan',
      'Pakistan',
      'India',
      'Nepal',
      'Bhutan',
      'Bangladesh',
      'Myanmar',
      'Thailand',
      'Laos',
      'Cambodia',
      'Vietnam',
      'Malaysia',
      'Singapore',
      'Indonesia',
      'Philippines',
      'Brunei',
      'China',
      'Japan',
      'South Korea',
      'North Korea',
      'Mongolia',
      'Australia',
      'New Zealand',
      'Fiji',
      'Papua New Guinea',
      'Solomon Islands',
      'Brazil',
      'Argentina',
      'Chile',
      'Peru',
      'Colombia',
      'Venezuela',
      'Ecuador',
      'Bolivia',
      'Paraguay',
      'Uruguay',
      'Guyana',
      'Suriname',
      'French Guiana',
      'Mexico',
      'Guatemala',
      'Belize',
      'El Salvador',
      'Honduras',
      'Nicaragua',
      'Costa Rica',
      'Panama',
      'Cuba',
      'Jamaica',
      'Haiti',
      'Dominican Republic',
      'Puerto Rico',
      'Bahamas',
      'Barbados',
      'Trinidad and Tobago',
      'Grenada',
      'South Africa',
      'Egypt',
      'Morocco',
      'Algeria',
      'Tunisia',
      'Libya',
      'Sudan',
      'Ethiopia',
      'Kenya',
      'Tanzania',
      'Uganda',
      'Rwanda',
      'Burundi',
      'Democratic Republic of the Congo',
      'Republic of the Congo',
      'Gabon',
      'Equatorial Guinea',
      'Cameroon',
      'Central African Republic',
      'Chad',
      'Niger',
      'Mali',
      'Burkina Faso',
      'Senegal',
      'Gambia',
      'Guinea-Bissau',
      'Guinea',
      'Sierra Leone',
      'Liberia',
      'Ivory Coast',
      'Ghana',
      'Togo',
      'Benin',
      'Nigeria',
      'Chad',
    ];

    final filtered = commonCountries
        .where((country) => country.toLowerCase().contains(query.toLowerCase()))
        .take(10)
        .map((name) => Country(name: name, code: 'XX'))
        .toList();

    setState(() {
      _countrySuggestions = filtered;
    });
  }

  Future<void> _searchCities(String query) async {
    query = query.trim();
    final country = _selectedCountry;
    if (country == null || query.length < 2) {
      setState(() => _citySuggestions = []);
      return;
    }

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
      final out = list
          .map<City>(
            (e) => City(
              name: e['name'] ?? '',
              country: e['country'] ?? '',
              countryCode: e['country_code'] ?? '',
              lat: (e['latitude'] as num?)?.toDouble() ?? 0.0,
              lon: (e['longitude'] as num?)?.toDouble() ?? 0.0,
              admin1: e['admin1'],
            ),
          )
          .where((e) => e.name.isNotEmpty)
          .toList();

      final result = out.take(10).toList();

      setState(() {
        _citySuggestions = result;
      });
    } catch (e) {
      setState(() => _citySuggestions = []);
    } finally {
      setState(() => _loadingCity = false);
    }
  }

  void _selectCountry(Country country) {
    setState(() {
      _selectedCountry = country;
      _countryController.text = country.name;
      _countrySuggestions = [];
      _cityController.clear();
      _citySuggestions = [];
    });
  }

  void _selectCity(City city) {
    setState(() {
      _cityController.text = city.name;
      _citySuggestions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   surfaceTintColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   // title: const Text(
      //   //   'TwinFinder',
      //   //   style: TextStyle(
      //   //     color: Colors.black,
      //   //     fontSize: 20,
      //   //     fontWeight: FontWeight.w600,
      //   //   ),
      //   // ),
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // #FFFFFF - белый сверху
              Color(0xFFEFF2FC), // #EFF2FC - светло-голубой снизу
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthProfileUpdateFailed) {
                // Убираем setState, чтобы не менять состояние страницы при ошибке
                // _isLoading будет сброшен в _updateProfile при следующей попытке

                // Парсим ошибку сервера для показа понятного сообщения
                String errorMessage = L.error(context);
                String errorTitle = L.error(context);

                if (state.message.contains('Validation error')) {
                  errorTitle = 'Validation Error';

                  // Проверяем конкретные ошибки валидации
                  if (state.message.contains('city') &&
                      state.message.contains('Invalid input')) {
                    errorMessage =
                        'Please select a valid city for the selected country';
                  } else if (state.message.contains('country') &&
                      state.message.contains('Invalid input')) {
                    errorMessage = 'Please select a valid country';
                  } else {
                    errorMessage = 'Please check all fields and try again';
                  }
                } else if (state.message.contains('422')) {
                  errorTitle = 'Validation Error';
                  errorMessage =
                      'Please check all required fields and try again';
                }

                ErrorHandler.showError(
                  context,
                  errorMessage,
                  title: errorTitle,
                );
              } else if (state is AuthAuthenticated) {
                // Profile updated successfully
                setState(() => _isLoading = false);
                ErrorHandler.showSuccess(
                  context,
                  'Profile updated successfully',
                  title: 'Success',
                );
                Navigator.of(context).pop();
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeArea(bottom: false, child: const SizedBox(height: 24)),
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        AppIcons.back,
                        colorFilter: ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        // Main Title
                        Text(
                          L.profileSettings(context),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            letterSpacing: 48 * (-1 / 100),
                            height: 1,
                            fontFamily: 'Bricolage Grotesque',
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Name Field
                        _buildTextField(
                          controller: _nameController,
                          label: L.name(context).toUpperCase(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return L.nameRequired(context);
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        // Birthday Field
                        _buildDateField(),

                        const SizedBox(height: 16),

                        // Gender Field
                        _buildGenderField(),

                        const SizedBox(height: 16),

                        // Country Field
                        _buildCountryField(),

                        const SizedBox(height: 8),

                        // City Field
                        _buildCityField(),

                        const SizedBox(height: 48),

                        // Update Profile Button
                        Center(
                          child: GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () async {
                                    HapticFeedback.lightImpact();
                                    await _updateProfile();
                                  },
                            child: Container(
                              height: 56,
                              width: 216,
                              decoration: BoxDecoration(
                                color:
                                    _formKey.currentState?.validate() == true &&
                                        _selectedDate != null &&
                                        _selectedGender != null
                                    ? AppColors.button
                                    : AppColors.button.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        L.updateProfile(context),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              _formKey.currentState
                                                          ?.validate() ==
                                                      true &&
                                                  _selectedDate != null &&
                                                  _selectedGender != null
                                              ? AppColors.white
                                              : AppColors.white.withValues(
                                                  alpha: 0.4,
                                                ),
                                          fontFamily: 'Bricolage Grotesque',
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SafeArea(top: false, child: const SizedBox(height: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: TextField(
                    focusNode: _nameFocus,
                    controller: controller,
                    cursorHeight: 16,
                    cursorColor: AppColors.backgroundTop,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
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
              // Floating label
              IgnorePointer(
                child: AnimatedAlign(
                  alignment: (_nameFocus.hasFocus || controller.text.isNotEmpty)
                      ? Alignment.topLeft
                      : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      left: 16,
                      top: (_nameFocus.hasFocus || controller.text.isNotEmpty)
                          ? 8
                          : 0,
                    ),
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontSize:
                            (_nameFocus.hasFocus || controller.text.isNotEmpty)
                            ? 12
                            : 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Bricolage Grotesque',
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: Text(_getLocalizedLabel(label)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.age(context).toUpperCase(),
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: () async {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) {
                      return Material(
                        child: Container(
                          height: 350,
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 50,
                                  color: Colors.black.withValues(alpha: 0.05),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 30),
                                  child: Text(
                                    L.done(context),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Bricolage Grotesque',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 300,
                                color: Colors.white,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime:
                                      _selectedDate ?? getMaximumBirthDate(),
                                  maximumDate: getMaximumBirthDate(),
                                  minimumDate: getMinimumBirthDate(),
                                  onDateTimeChanged: (date) {
                                    setState(() => _selectedDate = date);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            _selectedDate != null
                                ? formatDateToString(_selectedDate!)
                                : '',
                            style: const TextStyle(
                              fontFamily: 'Bricolage Grotesque',
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              // Floating label
              IgnorePointer(
                child: AnimatedAlign(
                  alignment: (_selectedDate != null)
                      ? Alignment.topLeft
                      : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      left: 16,
                      top: (_selectedDate != null) ? 8 : 0,
                    ),
                    child: AnimatedDefaultTextStyle(
                      style: TextStyle(
                        fontSize: (_selectedDate != null) ? 12 : 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontFamily: 'Bricolage Grotesque',
                      ),
                      duration: const Duration(milliseconds: 200),
                      child: Text(L.birthday(context)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.gender(context).toUpperCase(),
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),

        // Male option
        GestureDetector(
          onTap: () {
            setState(() => _selectedGender = 'male');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                SvgPicture.asset(AppIcons.male, height: 24, width: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    L.male(context),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Bricolage Grotesque',
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedGender == 'male'
                        ? AppColors.backgroundBottom
                        : Colors.grey[200],
                    border: Border.all(
                      color: _selectedGender == 'male'
                          ? AppColors.backgroundBottom
                          : Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: _selectedGender == 'male'
                      ? SvgPicture.asset(
                          AppIcons.check,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),

        // Female option
        GestureDetector(
          onTap: () {
            setState(() => _selectedGender = 'female');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                SvgPicture.asset(AppIcons.female, height: 24, width: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    L.female(context),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Bricolage Grotesque',
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedGender == 'female'
                        ? AppColors.backgroundBottom
                        : Colors.grey[200],
                    border: Border.all(
                      color: _selectedGender == 'female'
                          ? AppColors.backgroundBottom
                          : Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: _selectedGender == 'female'
                      ? SvgPicture.asset(
                          AppIcons.check,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),

        // Other option
        // GestureDetector(
        //   onTap: () {
        //     setState(() => _selectedGender = 'other');
        //   },
        //   child: Container(
        //     height: 72,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(16),
        //       border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
        //     ),
        //     child: Row(
        //       children: [
        //         const SizedBox(width: 16),
        //         const Icon(Icons.person_outline, size: 24, color: Colors.black),
        //         const SizedBox(width: 16),
        //         const Expanded(
        //           child: Text(
        //             'Other',
        //             style: TextStyle(
        //               fontSize: 20,
        //               fontWeight: FontWeight.w500,
        //               fontFamily: 'Bricolage Grotesque',
        //               color: Colors.black,
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 16),
        //         Container(
        //           height: 32,
        //           width: 32,
        //           decoration: BoxDecoration(
        //             shape: BoxShape.circle,
        //             color: _selectedGender == 'other'
        //                 ? AppColors.backgroundBottom
        //                 : Colors.grey[200],
        //             border: Border.all(
        //               color: _selectedGender == 'other'
        //                   ? AppColors.backgroundBottom
        //                   : Colors.grey[400]!,
        //               width: 1,
        //             ),
        //           ),
        //           child: _selectedGender == 'other'
        //               ? SvgPicture.asset(
        //                   AppIcons.check,
        //                   colorFilter: const ColorFilter.mode(
        //                     Colors.white,
        //                     BlendMode.srcIn,
        //                   ),
        //                 )
        //               : null,
        //         ),
        //         const SizedBox(width: 16),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.location(context).toUpperCase(),
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
          ),
          child: Column(
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextField(
                          focusNode: _countryFocus,
                          controller: _countryController,
                          onChanged: (v) {
                            _debounced(() => _searchCountries(v));
                          },
                          cursorHeight: 16,
                          cursorColor: AppColors.backgroundTop,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            suffixIcon: _loadingCountry
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
                            fontFamily: 'Bricolage Grotesque',
                          ),
                        ),
                      ),
                    ),
                    // Floating label
                    IgnorePointer(
                      child: AnimatedAlign(
                        alignment:
                            (_countryFocus.hasFocus ||
                                _countryController.text.isNotEmpty)
                            ? Alignment.topLeft
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.only(
                            left: 16,
                            top:
                                (_countryFocus.hasFocus ||
                                    _countryController.text.isNotEmpty)
                                ? 8
                                : 0,
                          ),
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize:
                                  (_countryFocus.hasFocus ||
                                      _countryController.text.isNotEmpty)
                                  ? 12
                                  : 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Text('Country'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_countrySuggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _countrySuggestions.length,
                    itemBuilder: (context, index) {
                      final country = _countrySuggestions[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(
                          country.name,
                          style: const TextStyle(
                            fontFamily: 'Bricolage Grotesque',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onTap: () => _selectCountry(country),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   'CITY',
        //   style: TextStyle(
        //     fontFamily: 'Bricolage Grotesque',
        //     fontSize: 12,
        //     fontWeight: FontWeight.bold,
        //     color: Colors.black,
        //   ),
        // ),
        // const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
          ),
          child: Column(
            children: [
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFEBEEFF), width: 1),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: TextField(
                          focusNode: _cityFocus,
                          controller: _cityController,
                          onChanged: (v) => _debounced(() => _searchCities(v)),
                          cursorHeight: 16,
                          cursorColor: AppColors.backgroundTop,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            suffixIcon: _loadingCity
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
                            fontFamily: 'Bricolage Grotesque',
                          ),
                        ),
                      ),
                    ),
                    // Floating label
                    IgnorePointer(
                      child: AnimatedAlign(
                        alignment:
                            (_cityFocus.hasFocus ||
                                _cityController.text.isNotEmpty)
                            ? Alignment.topLeft
                            : Alignment.centerLeft,
                        duration: const Duration(milliseconds: 200),
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.only(
                            left: 16,
                            top:
                                (_cityFocus.hasFocus ||
                                    _cityController.text.isNotEmpty)
                                ? 8
                                : 0,
                          ),
                          child: AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize:
                                  (_cityFocus.hasFocus ||
                                      _cityController.text.isNotEmpty)
                                  ? 12
                                  : 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                            duration: const Duration(milliseconds: 200),
                            child: Text('City'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_citySuggestions.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _citySuggestions.length,
                    itemBuilder: (context, index) {
                      final city = _citySuggestions[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(
                          city.name,
                          style: const TextStyle(
                            fontFamily: 'Bricolage Grotesque',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        // subtitle: Text(
                        //   [
                        //     if (city.admin1 != null) city.admin1,
                        //     city.country,
                        //   ].where((e) => e != null).join(', '),
                        //   style: TextStyle(
                        //     color: Colors.grey[600],
                        //     fontSize: 14,
                        //   ),
                        // ),
                        onTap: () => _selectCity(city),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getLocalizedLabel(String label) {
    switch (label.toUpperCase()) {
      case 'NAME':
        return L.yourName(context);
      case 'AGE':
        return L.yourAge(context);
      case 'GENDER':
        return L.yourGender(context);
      case 'LOCATION':
        return L.yourCountry(context);
      case 'CITY':
        return L.yourCity(context);
      case 'COUNTRY':
        return L.yourCountry(context);
      default:
        return L.yourName(context); // Fallback на локализованный текст
    }
  }
}

// Helper classes for country and city search
class Country {
  final String name;
  final String code;
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
}
