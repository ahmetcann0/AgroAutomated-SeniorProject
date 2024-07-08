import 'package:agroautomated/app_theme.dart';
import 'package:agroautomated/pages/home_page.dart';
import 'package:agroautomated/pages/myplants_list_page.dart';
// import 'package:agroautomated/pages/test_page.dart'; // Removed the import for TestPage
import 'package:agroautomated/pages/user_page.dart';
import 'package:agroautomated/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedBottomNavIndexProvider = StateProvider<int>((ref) => 0);

class AppBottomNavigator extends ConsumerWidget {
  const AppBottomNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeState = ref.watch(appThemeStateNotifier);

    final currentIndex = ref.watch(selectedBottomNavIndexProvider);
    final List<Widget> pages = [
      HomePage(),
      MyPlantsListPage(),
      UserPage(),
    ];

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            appThemeState.isDarkModeEnabled ? Colors.black : Colors.white,
        showUnselectedLabels: true,
        selectedItemColor: Color(0xFF0D986A),
        unselectedItemColor: appThemeState.isDarkModeEnabled
            ? AppTheme.darkTheme.canvasColor
            : AppTheme.lightTheme.canvasColor,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(selectedBottomNavIndexProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_florist_outlined),
            label: 'My Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
