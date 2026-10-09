import 'package:flutter/widgets.dart';

enum OrbitLayout { mobile, tablet, desktop }

extension OrbitLayoutContext on BuildContext {
  OrbitLayout get orbitLayout {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 600) return OrbitLayout.mobile;
    if (width < 1024) return OrbitLayout.tablet;
    return OrbitLayout.desktop;
  }

  bool get isOrbitCompact => orbitLayout == OrbitLayout.mobile;
}
