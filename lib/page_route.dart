import 'package:concentric_transition/clipper.dart';
import 'package:flutter/material.dart';

class ConcentricPageRoute<T> extends PageRoute<T> {
  ConcentricPageRoute({
    required this.builder,
    this.verticalPosition = .85,
    this.radius = 30,
    this.growFactor = 30,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  }) : super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  final double verticalPosition;
  final double radius;
  final double growFactor;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 700);

  @override
  bool get opaque => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is ConcentricPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is ConcentricPageRoute && !nextRoute.fullscreenDialog);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget? result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {

    return Container(
      child: ClipPath(
        clipper: ConcentricClipper(
          progress: animation.drive(CurveTween(curve: Curves.easeIn)).value,
          verticalPosition: verticalPosition,
          radius: radius,
          growFactor: growFactor,
        ),
        child: child,
      ),
    );
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
