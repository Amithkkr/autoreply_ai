// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginPage();
    },
  );
}

/// generated route for
/// [ReviewDetailPage]
class ReviewDetailRoute extends PageRouteInfo<ReviewDetailRouteArgs> {
  ReviewDetailRoute({
    Key? key,
    required String reviewId,
    List<PageRouteInfo>? children,
  }) : super(
         ReviewDetailRoute.name,
         args: ReviewDetailRouteArgs(key: key, reviewId: reviewId),
         initialChildren: children,
       );

  static const String name = 'ReviewDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ReviewDetailRouteArgs>();
      return ReviewDetailPage(key: args.key, reviewId: args.reviewId);
    },
  );
}

class ReviewDetailRouteArgs {
  const ReviewDetailRouteArgs({this.key, required this.reviewId});

  final Key? key;

  final String reviewId;

  @override
  String toString() {
    return 'ReviewDetailRouteArgs{key: $key, reviewId: $reviewId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ReviewDetailRouteArgs) return false;
    return key == other.key && reviewId == other.reviewId;
  }

  @override
  int get hashCode => key.hashCode ^ reviewId.hashCode;
}

/// generated route for
/// [ReviewPrototypePage]
class ReviewPrototypeRoute extends PageRouteInfo<void> {
  const ReviewPrototypeRoute({List<PageRouteInfo>? children})
    : super(ReviewPrototypeRoute.name, initialChildren: children);

  static const String name = 'ReviewPrototypeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReviewPrototypePage();
    },
  );
}
