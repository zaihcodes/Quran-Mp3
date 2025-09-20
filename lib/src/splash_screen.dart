import 'package:flutter/material.dart';
import 'package:quran_mp3/core/services/theme/app_colors.dart';
import 'package:quran_mp3/src/quran_audio/presentation/screens/reciters_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigateToRecitersScreen();
  }

  Future<void> _navigateToRecitersScreen() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const RecitersScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.darkPrimaryColor,
        body: Center(
          child: SizedBox(
            width: 150,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset('assets/images/quran_mp3_icon.jpg')),
          ),
        ));
  }
}
