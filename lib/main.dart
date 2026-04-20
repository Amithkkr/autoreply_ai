import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autoreply_ai/core/db/app_db.dart';
import 'package:autoreply_ai/core/locator/locator.dart';
import 'package:autoreply_ai/generated/l10n.dart';
import 'package:autoreply_ai/router/app_router.dart';
import 'package:autoreply_ai/theme/app_theme.dart';
import 'package:autoreply_ai/theme/design_tokens.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await DesignTokens.load();
      await setupLocator();
      await locator.isReady<AppDB>();

      /// Disable debugPrint logs in production
      if (kReleaseMode) {
        debugPrint = (String? message, {int? wrapWidth}) {};
      }

      // Fixing App Orientation.
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]).then(
        (value) => runApp(MyApp(appRouter: locator<AppRouter>())),
      );
    },
    (error, stack) {
      if (!kReleaseMode) {
        debugPrint('[Error]: $error');
        debugPrint('[Stacktrace]: $stack');
      }
    },
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({required this.appRouter, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        title: 'AutoReply AI',
        theme: buildAppTheme(DesignTokens.instance),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.config(),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
