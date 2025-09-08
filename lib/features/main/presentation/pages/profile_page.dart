import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twin_finder/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/utils/flag_emoji.dart';
import 'package:twin_finder/core/utils/app_formaters.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/localization/export.dart';
import 'package:get_it/get_it.dart';
import 'package:twin_finder/core/utils/token_secure.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _requestedLoad = false;

  void _ensureProfileLoaded(BuildContext context, AuthState state) {
    if (_requestedLoad) return;
    // If we're on the profile tab and not authenticated yet, try to load profile once
    if (state is! AuthAuthenticated && state is! AuthUnauthenticated) {
      _requestedLoad = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AuthCubit>().loadProfile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthPhotoUploaded) {
              context.read<AuthCubit>().loadProfile();
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              _ensureProfileLoaded(context, state);
              if (state is AuthAuthenticated) {
                final user = state.me.data;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Photo
                      const SizedBox(height: 4),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: double.infinity,
                            height: 516,
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                user.profilePhotoUrl != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: _buildProfileImage(
                                          user.profilePhotoUrl!,
                                          fallbackName: user.name,
                                        ),
                                      )
                                    : _buildDefaultPhoto(user.name, context),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 180,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0),
                                          Colors.black.withOpacity(0.95),
                                        ],
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          state.me.data.name,
                                          style: TextStyle(
                                            fontSize: 40,
                                            height: 40 / 48,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            fontFamily: 'Bricolage Grotesque',
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          formatAgeFromBirthday(
                                            state.me.data.birthday,
                                          ),
                                          style: TextStyle(
                                            fontSize: 20,
                                            height: 20 / 24,
                                            fontFamily: 'Bricolage Grotesque',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    height: 32,
                                    margin: const EdgeInsets.only(
                                      top: 16,
                                      left: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          FlagEmoji.getCountryFlag(
                                            state.me.data.country,
                                          ),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          state.me.data.city ?? '',
                                          style: TextStyle(
                                            fontSize: 16,
                                            height: 16 / 20,
                                            fontFamily: 'Bricolage Grotesque',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // First Block: Profile Settings
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundBottom,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppIcons.smile,
                                    height: 20,
                                  ),
                                ),
                                title: Text(
                                  L.changePhoto(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: 'Bricolage Grotesque',
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoutes.faceCapturePage)
                                      .then((_) {
                                    // After returning from capture, refresh profile from server
                                    if (mounted) {
                                      context.read<AuthCubit>().loadProfile();
                                    }
                                  });
                                },
                              ),
                            ),

                            const Divider(
                              height: 1,
                              indent: 55,
                              endIndent: 0,
                              color: Color(0xFFEFF2FC),
                            ),

                            // Change Profile Details Button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  height: 32,
                                  width: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundBottom,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: SvgPicture.asset(
                                    AppIcons.edit,
                                    height: 20,
                                  ),
                                ),

                                title: Text(
                                  L.editProfile(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Bricolage Grotesque',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(AppRoutes.changeProfileDetails);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Second Block: Logout
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF3F8E),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              L.logout(context),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Bricolage Grotesque',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 16,
                            ),
                            onTap: () {
                              // Показываем диалог подтверждения
                              _showLogoutConfirmationDialog(context);
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                );
              }

              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF3F8E)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultPhoto(String name, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF3F8E), Color(0xFFFF7A00)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF3F8E),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              L.changePhoto(context),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(String url, {required String fallbackName}) {
    final cacheBust = DateTime.now().millisecondsSinceEpoch;
    final uri = Uri.parse(_normalizePhotoUrl(url));
    final bustUrl = uri.replace(queryParameters: {
      ...uri.queryParameters,
      'v': cacheBust.toString(),
    }).toString();

    return FutureBuilder<String?>(
      future: GetIt.I<TokenStore>().access,
      builder: (context, snapshot) {
        final token = snapshot.data;
        return Image.network(
          bustUrl,
          fit: BoxFit.cover,
          headers: token != null && token.isNotEmpty
              ? {'Authorization': 'Bearer $token'}
              : const {},
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultPhoto(fallbackName, context);
          },
        );
      },
    );
  }

  String _normalizePhotoUrl(String url) {
    // Backend sometimes returns an IP:port http URL that 404s.
    // Normalize to the public HTTPS host.
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,

          title: Text(
            L.logout(context),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'Bricolage Grotesque',
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            L.logoutConfirmation(context),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontFamily: 'Bricolage Grotesque',
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Закрываем диалог
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        L.no(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Закрываем диалог
                        context.read<AuthCubit>().logout();
                        // Сначала переходим на экран авторизации с красивой анимацией, потом выполняем logout
                        context.animatedRoute(AppRoutes.auth);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        L.yes(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        );
      },
    );
  }
}
