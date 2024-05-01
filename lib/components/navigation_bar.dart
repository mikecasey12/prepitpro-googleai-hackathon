import 'package:flutter/material.dart';
import 'package:prepitpro/theme/theme.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

class MainNavigationBar extends StatelessWidget {
  final Function(int)? changeIndexFn;
  final int? currentPageIndex;
  final BuildContext context;

  const MainNavigationBar(
      {super.key,
      required this.changeIndexFn,
      required this.currentPageIndex,
      required this.context});

  List<BottomNavigationBarItem> bottomNavItems() {
    const double height = 40;
    const double width = 40;
    const double iconHeight = 24;
    final activeColor = Theme.of(context).colorScheme.secondary;
    final isDark = ThemeController.themeMode.value == ThemeMode.dark;
    return [
      BottomNavigationBarItem(
          icon: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                color:
                    currentPageIndex == 0 ? activeColor : Colors.transparent),
            child: Image(
              image: const Svg('assets/icons/home.svg'),
              height: iconHeight,
              color: currentPageIndex == 0
                  ? null
                  : isDark
                      ? activeColor
                      : Colors.black87,
            ),
          ),
          label: "Home"),
      BottomNavigationBarItem(
          icon: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color:
                      currentPageIndex == 1 ? activeColor : Colors.transparent),
              child: Image(
                image: const Svg("assets/icons/subject.svg"),
                height: iconHeight,
                color: currentPageIndex == 1
                    ? null
                    : isDark
                        ? activeColor
                        : Colors.black87,
              )),
          label: "Subjects"),
      BottomNavigationBarItem(
          icon: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(500),
                  color:
                      currentPageIndex == 2 ? activeColor : Colors.transparent),
              child: Image(
                image: const Svg("assets/icons/user.svg"),
                height: iconHeight,
                color: currentPageIndex == 2
                    ? null
                    : isDark
                        ? activeColor
                        : Colors.black87,
              )),
          label: "Profile"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 0,
      selectedFontSize: 0,
      items: bottomNavItems(),
      currentIndex: currentPageIndex!,
      iconSize: 24,
      onTap: changeIndexFn!,
      type: BottomNavigationBarType.shifting,
      fixedColor: Colors.black87,
      unselectedItemColor: Colors.black38,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
