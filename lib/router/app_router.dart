import 'package:auto_route/auto_route.dart';
import 'package:autoreply_ai/core/locator/locator.dart';
import 'package:autoreply_ai/ui/login/login_page.dart';
import 'package:autoreply_ai/ui/review/review_detail_page.dart';
import 'package:autoreply_ai/ui/review/review_prototype_page.dart';
import 'package:flutter/widgets.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: ReviewPrototypeRoute.page, initial: true),
    AutoRoute(page: ReviewDetailRoute.page),
  ];
}

final appRouter = locator<AppRouter>();
