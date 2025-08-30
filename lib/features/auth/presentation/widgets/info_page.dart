import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twin_finder/core/router/app_routes.dart';
import 'package:twin_finder/core/router/navigation.dart';
import 'package:twin_finder/core/utils/app_colors.dart';
import 'package:twin_finder/core/utils/app_images.dart';
import 'package:twin_finder/features/auth/presentation/widgets/background_widget.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 32,
                width: 32,
                margin: EdgeInsets.only(left: 16),
                color: Colors.transparent,
                alignment: Alignment.center,
                child: SvgPicture.asset(AppIcons.back, height: 32, width: 32),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Last step. Let\'s\ntake a selfie!',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 48 * (-1 / 100),
                  height: 1,
                  fontFamily: 'Bricolage Grotesque',
                ),
              ),
            ),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {},
              child: Container(
                // height: 96,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Image.asset(AppImages.smile, height: 76),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Clearly show your face',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'No masks, heavy filters, or other people, just the real you.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Bricolage Grotesque',
                              color: AppColors.subtitle,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {},
              child: Container(
                // height: 96,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Image.asset(AppImages.smileTwo, height: 76),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Only you in the photo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'No group pics, celebrities, or photos that aren’t yours.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Bricolage Grotesque',
                              color: AppColors.subtitle,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {},
              child: Container(
                // height: 96,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 16),
                    Image.asset(AppImages.smileThird, height: 76),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            'Keep it clean',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Bricolage Grotesque',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'No nudity, underwear shots, or anything too provocative.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Bricolage Grotesque',
                              color: AppColors.subtitle,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    context.onlyAnimatedRoute(AppRoutes.location);
                    // Navigate to the next page or perform an action
                  },
                  child: Container(
                    height: 56,
                    width: 216,
                    decoration: BoxDecoration(
                      color: AppColors.button,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontFamily: 'Bricolage Grotesque',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
