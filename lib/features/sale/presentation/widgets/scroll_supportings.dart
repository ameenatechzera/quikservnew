import 'package:flutter/material.dart';

/// ✅ Reduced bounce (soft “drop & settle”)
class SoftBounceScrollPhysics extends BouncingScrollPhysics {
  const SoftBounceScrollPhysics({ScrollPhysics? parent})
    : super(parent: parent);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // 🔽 smaller = less bounce (0.25 very subtle, 0.35 mild)
    return offset * 0.30;
  }

  @override
  double get minFlingVelocity => 1200;
}

/// ✅ Apply physics globally + remove Android glow
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const SoftBounceScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // remove glow
  }
}
