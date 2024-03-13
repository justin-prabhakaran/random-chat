import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'desktop_home_page.dart';
import 'mobile_home_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return const MobileHomePage();
        }
        if (sizingInformation.isDesktop) {
          return const DesktopHomePage();
        }
        return const DesktopHomePage();
      },
    );
  }
}
