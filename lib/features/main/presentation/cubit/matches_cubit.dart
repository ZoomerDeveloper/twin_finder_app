import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twin_finder/api/models/match_list_response.dart';
import 'package:twin_finder/api/models/match_with_user.dart';
import 'package:twin_finder/features/main/presentation/repository/matches_repository.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  final MatchesRepository _repository;

  // Cache for matches data to avoid repeated requests
  MatchListResponse? _cachedMatches;
  bool _hasLoadedMatches = false;

  MatchesCubit(this._repository) : super(MatchesInitial());

  Future<void> loadMatches({int page = 0, int perPage = 20}) async {
    debugPrint('loadMatches called with page: $page, perPage: $perPage');

    // Prevent multiple simultaneous requests
    if (_hasLoadedMatches && page == 0) {
      debugPrint('Matches already loaded, skipping...');
      return;
    }

    debugPrint('Emitting MatchesLoading state');
    emit(MatchesLoading());

    try {
      // Use cached data for first page if available
      MatchListResponse response;
      if (page == 0 && _cachedMatches != null) {
        debugPrint('Using cached matches data');
        response = _cachedMatches!;
      } else {
        debugPrint('Loading matches from API...');
        response = await _repository.getMatches(page: page, perPage: perPage);
        debugPrint('API response received: ${response.matches.length} matches');
        // Cache first page data
        if (page == 0) {
          _cachedMatches = response;
          _hasLoadedMatches = true;
          debugPrint('Matches loaded from API and cached');
        }
      }

      debugPrint(
        'Emitting MatchesLoaded state with ${response.matches.length} matches',
      );
      debugPrint(
        'Response details: hasNext=${response.hasNext}, hasPrev=${response.hasPrev}, total=${response.total}',
      );
      emit(
        MatchesLoaded(
          matches: response.matches,
          hasNext: response.hasNext,
          hasPrev: response.hasPrev,
          currentPage: page,
        ),
      );
    } catch (e) {
      debugPrint('Error loading matches: $e');
      emit(MatchesFailure(e.toString()));
    }
  }

  Future<void> loadMoreMatches() async {
    final currentState = state;
    if (currentState is MatchesLoaded && currentState.hasNext) {
      try {
        final nextPage = currentState.currentPage + 1;
        final response = await _repository.getMatches(page: nextPage);

        // Combine existing matches with new ones
        final allMatches = [...currentState.matches, ...response.matches];

        emit(
          MatchesLoaded(
            matches: allMatches,
            hasNext: response.hasNext,
            hasPrev: response.hasPrev,
            currentPage: nextPage,
          ),
        );
      } catch (e) {
        emit(MatchesFailure(e.toString()));
      }
    }
  }

  void refreshMatches() {
    // Clear cache and reload
    _cachedMatches = null;
    _hasLoadedMatches = false;
    loadMatches();
  }
}
