import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twin_finder/api/models/matches_response.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/features/main/presentation/cubit/matches_cubit.dart';

class TwinFinderPage extends StatefulWidget {
  const TwinFinderPage({super.key});

  @override
  State<TwinFinderPage> createState() => _TwinFinderPageState();
}

class _TwinFinderPageState extends State<TwinFinderPage> {
  @override
  void initState() {
    super.initState();
    // Load matches when page is initialized
    context.read<MatchesCubit>().loadMatches();
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
                                      childAspectRatio: 0.8,
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

  Widget _buildMatchCard(Match match) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: match.similarityColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
              child: match.matchedUserProfilePhotoUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        match.matchedUserProfilePhotoUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            match.matchedUserName.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: match.similarityColor,
                            ),
                          );
                        },
                      ),
                    )
                  : Text(
                      match.matchedUserName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: match.similarityColor,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            match.matchedUserName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // Similarity
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: match.similarityColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${match.similarityPercentage}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Similarity Level
          Text(
            match.similarityLevel,
            style: TextStyle(
              color: match.similarityColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // View Profile Button
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to match profile
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: match.similarityColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: match.similarityColor, width: 1),
                  ),
                ),
                child: const Text(
                  'View Profile',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
