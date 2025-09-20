import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mp3/core/services/theme/theme_data_provider.dart';
import 'package:quran_mp3/src/quran_audio/presentation/bloc/reciter/reciter_bloc.dart';
import 'package:quran_mp3/core/services/injection_dep/injection_containers.dart'
    as di;
import 'package:quran_mp3/src/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ReciterBloc>()..add(GetGroupedReciters()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran Audio Player',
        theme: ThemeDataProvider.lightTheme,
        // home: const RecitersScreen(),
        home: const SplashScreen(),
        // home: const SurahPlayScreen(),
      ),
    );
  }
}
