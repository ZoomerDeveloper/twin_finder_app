part of 'matches_cubit.dart';

sealed class MatchesState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class MatchesInitial extends MatchesState {}

final class MatchesLoading extends MatchesState {}

final class MatchesLoaded extends MatchesState {
  final List<Match> matches;
  final bool hasNext;
  final bool hasPrev;
  final int currentPage;

  MatchesLoaded({
    required this.matches,
    required this.hasNext,
    required this.hasPrev,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [matches, hasNext, hasPrev, currentPage];
}

final class MatchesFailure extends MatchesState {
  final String message;

  MatchesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
