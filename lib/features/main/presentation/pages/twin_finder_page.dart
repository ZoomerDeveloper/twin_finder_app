import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twin_finder/api/models/match_with_user.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/features/main/presentation/cubit/matches_cubit.dart';

class TwinFinderPage extends StatefulWidget {
  const TwinFinderPage({super.key});

  @override
  State<TwinFinderPage> createState() => _TwinFinderPageState();
}

class _TwinFinderPageState extends State<TwinFinderPage> {
  bool _hasLoadedMatches = false;

  @override
  void initState() {
    super.initState();
    debugPrint('TwinFinderPage initState called');
    // Load matches only when page is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
        'TwinFinderPage postFrameCallback called, mounted: $mounted, _hasLoadedMatches: $_hasLoadedMatches',
      );
      if (mounted && !_hasLoadedMatches) {
        _hasLoadedMatches = true;
        debugPrint('Calling loadMatches from TwinFinderPage');
        try {
          final cubit = context.read<MatchesCubit>();
          debugPrint('MatchesCubit found, calling loadMatches');
          cubit.loadMatches();
        } catch (e) {
          debugPrint('Error accessing MatchesCubit: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'TwinFinder',
          style: TextStyle(
            color: AppColors.backgroundBottom,
            fontSize: 24,
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
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
        child: SafeArea(
          child: BlocBuilder<MatchesCubit, MatchesState>(
            builder: (context, state) {
              if (state is MatchesLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF3F8E)),
                );
              }

              if (state is MatchesFailure) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load matches',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.read<MatchesCubit>().loadMatches();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3F8E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MatchesLoaded) {
                final matches = state.matches;

                return CustomScrollView(
                  slivers: [
                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            const Text(
                              'Found Matches',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${matches.length} people look similar to you',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Matches Grid
                            if (matches.isNotEmpty)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      // Tall cards with fixed aspect avoid overflow
                                      childAspectRatio: 0.62,
                                    ),
                                itemCount: matches.length,
                                itemBuilder: (context, index) {
                                  final match = matches[index];
                                  return _buildMatchCard(match);
                                },
                              )
                            else
                              _buildEmptyState(),

                            // Pagination
                            if (state.hasNext)
                              Padding(
                                padding: const EdgeInsets.only(top: 24),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<MatchesCubit>()
                                          .loadMoreMatches();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF3F8E),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text('Load More'),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const Center(
                child: Text(
                  'No matches found',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getSimilarityColor(MatchWithUser match) {
    if (match.isHighSimilarity) return Colors.green;
    if (match.isMediumSimilarity) return Colors.orange;
    if (match.isLowSimilarity) return Colors.red;
    return Colors.red; // default
  }

  String _getSimilarityLevel(MatchWithUser match) {
    if (match.isHighSimilarity) return 'High';
    if (match.isMediumSimilarity) return 'Medium';
    if (match.isLowSimilarity) return 'Low';
    return 'Low'; // default
  }

  Widget _buildMatchCard(MatchWithUser match) {
    final photoUrl = match.matchedUserProfilePhotoUrl;
    final normalized = _normalizePhotoUrl(photoUrl);
    final cacheBust = DateTime.now().millisecondsSinceEpoch;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Photo
          AspectRatio(
            aspectRatio: 9 / 16,
            child: normalized != null
                ? Image.network(
                    '$normalized?v=$cacheBust',
                    fit: BoxFit.cover,
                  )
                : Container(color: Colors.grey[300]),
          ),

          // Gradient bottom overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.85),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    match.matchedUserName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${match.similarityPercentage}% MATCH',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _normalizePhotoUrl(String? url) {
    if (url == null) return null;
    try {
      final u = Uri.parse(url);
      if (u.host == '161.97.64.169') {
        return Uri.parse('https://api.twinfinder.app${u.path}').toString();
      }
      if (u.scheme == 'http') {
        return url.replaceFirst('http://', 'https://');
      }
      return url;
    } catch (_) {
      return url;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No matches found yet',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re still analyzing your profile. Check back later!',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
