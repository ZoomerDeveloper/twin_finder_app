import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/core/localization/export.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
          child: Column(
            children: [
              // Coming Soon Content
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3F8E).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: SvgPicture.asset(
                          AppIcons.chat,
                          height: 60,
                          width: 60,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        L.comingSoon(context),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 4),

                      // Description
                      // Horizontal spacing 51 in figma
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 51),
                        child: Text(
                          L.chatsNotAvailable(context),
                          style: TextStyle(
                            color: Color(0xFF51575C),
                            fontFamily: 'Bricolage Grotesque',
                            fontSize: 16,
                            // Line height 20 in figma
                            height: 20 / 16,
                          ),
                          textAlign: TextAlign.center,
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
    );
  }
}
