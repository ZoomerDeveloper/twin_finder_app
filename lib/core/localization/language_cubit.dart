import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'language_service.dart';

// Events
abstract class LanguageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final String languageCode;

  LanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageLoaded extends LanguageEvent {}

// States
abstract class LanguageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageLoadedState extends LanguageState {
  final String currentLanguage;
  final String previousLanguage;

  LanguageLoadedState({
    required this.currentLanguage,
    required this.previousLanguage,
  });

  @override
  List<Object?> get props => [currentLanguage, previousLanguage];
}

class LanguageError extends LanguageState {
  final String message;

  LanguageError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  Future<void> loadLanguage() async {
    emit(LanguageLoading());
    try {
      final savedLanguage = await LanguageService.getSavedLanguage();
      emit(
        LanguageLoadedState(
          currentLanguage: savedLanguage,
          previousLanguage: savedLanguage,
        ),
      );
    } catch (e) {
      emit(LanguageError('Failed to load language: $e'));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      final currentState = state;
      String previousLanguage = 'en';

      if (currentState is LanguageLoadedState) {
        previousLanguage = currentState.currentLanguage;
      }

      await LanguageService.saveLanguage(languageCode);

      emit(
        LanguageLoadedState(
          currentLanguage: languageCode,
          previousLanguage: previousLanguage,
        ),
      );
    } catch (e) {
      emit(LanguageError('Failed to change language: $e'));
    }
  }

  String getCurrentLanguage() {
    if (state is LanguageLoadedState) {
      return (state as LanguageLoadedState).currentLanguage;
    }
    return 'en';
  }

  bool isLanguageChanged() {
    if (state is LanguageLoadedState) {
      final loadedState = state as LanguageLoadedState;
      return loadedState.currentLanguage != loadedState.previousLanguage;
    }
    return false;
  }
}
