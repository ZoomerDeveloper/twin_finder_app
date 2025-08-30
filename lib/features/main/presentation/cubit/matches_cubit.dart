import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:twin_finder/api/models/matches_response.dart';
import 'package:twin_finder/features/main/presentation/repository/matches_repository.dart';

part 'matches_state.dart';

class MatchesCubit extends Cubit<MatchesState> {
  final MatchesRepository _repository;

  MatchesCubit(this._repository) : super(MatchesInitial());

  Future<void> loadMatches({int page = 0, int perPage = 20}) async {
    emit(MatchesLoading());

    try {
      final response = await _repository.getMatches(
        page: page,
        perPage: perPage,
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
    loadMatches();
  }
}
