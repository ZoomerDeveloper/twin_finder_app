import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twin_finder/features/main/presentation/pages/profile_page.dart';
import 'package:twin_finder/features/main/presentation/pages/twin_finder_page.dart';
import 'package:twin_finder/features/main/presentation/pages/chat_page.dart';
import 'package:twin_finder/features/main/presentation/cubit/matches_cubit.dart';
import 'package:twin_finder/features/main/presentation/repository/matches_repository.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/core/utils/di.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:dio/dio.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;
  late MatchesCubit _matchesCubit;

  @override
  void initState() {
    super.initState();
    _matchesCubit = MatchesCubit(MatchesRepository(sl<Dio>()));
  }

  @override
  void dispose() {
    _matchesCubit.close();
    super.dispose();
  }

  List<Widget> get _pages => [
    const ProfilePage(),
    BlocProvider.value(value: _matchesCubit, child: const TwinFinderPage()),
    const ChatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Reset authentication failure flag in MatchesCubit when user successfully authenticates
        if (state is AuthAuthenticated ||
            state is AuthNeedsProfileSetupWithData) {
          _matchesCubit.resetAuthenticationFailure();
        }
      },
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: Container(
          height: 120,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEFF2FC), width: 1)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFFEFF2FC),
              selectedItemColor: Colors.black,
              unselectedItemColor: const Color(0xFFA1A5AC),
              elevation: 0,
              enableFeedback: false,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              iconSize: 0,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppIcons.profile,
                    height: 40,
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFA1A5AC),
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    AppIcons.profile,
                    height: 40,
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: '',
                  backgroundColor: Colors.transparent,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppIcons.swipes,
                    height: 40,
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFA1A5AC),
                      BlendMode.srcIn,
                    ),
                  ),
                  activeIcon: SvgPicture.asset(
                    AppIcons.swipes,
                    height: 40,
                    width: 40,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: '',
                  backgroundColor: Colors.transparent,
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(AppIcons.chat, height: 56),
                  label: '',
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
