import 'package:auto_route/auto_route.dart';
import 'package:autoreply_ai/core/locator/locator.dart';
import 'package:autoreply_ai/ui/login/login_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: LoginRoute.page, initial: true),
  ];
}

final appRouter = locator<AppRouter>();
