import 'package:afforestation_app/core/localization/app_asset_loader.dart';
import 'package:afforestation_app/core/routes/app_router.dart';
import 'package:afforestation_app/core/services/local/shared_pref.dart';
import 'package:afforestation_app/core/services/apis/dio_provider.dart';
import 'package:afforestation_app/core/styles/themes.dart';
import 'package:afforestation_app/core/theme/theme_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  DioProvider.init();
  await SharedPref.init();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      useOnlyLangCode: true,
      useFallbackTranslations: true,
      assetLoader: const AppAssetLoader(),
      child: BlocProvider<ThemeCubit>(
        create: (_) => ThemeCubit(),
        child: const MainApp(),
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: AppRouter.routes,
        );
      },
    );
  }
}
