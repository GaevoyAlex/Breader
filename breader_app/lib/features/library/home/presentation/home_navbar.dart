import 'package:breader_app/features/library/home/presentation/screens/history/history_screen.dart';
import 'package:breader_app/features/library/home/presentation/screens/library/library_screen.dart';
import 'package:breader_app/features/library/home/presentation/screens/settings/settings_screen.dart';
import 'package:breader_app/features/library/home/utils/nav_home_u.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

final List<Widget> _screens = [
  Library_Screen(),
  History_Screen(),
  Settings_Screen()
];

class HomePresentation extends StatelessWidget {
  const HomePresentation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: Scaffold(
        body: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, child) {
            return _screens[navigationProvider.selectedIndex];
          },
        ),
        bottomNavigationBar: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, child) {
            return Container(
              child: SafeArea(
                child: GNav(
                  rippleColor: Color.fromARGB(151, 59, 114, 255),
                  hoverColor: Color.fromARGB(151, 63, 69, 242),
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 30,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: Duration(milliseconds: 400),
                  tabBackgroundColor: Color.fromARGB(84, 122, 189, 255)!,
                  color: Colors.black,
                  tabs: const [
                    GButton(
                      icon: Icons.book,
                      text: 'Первый',
                    ),
                    GButton(
                      icon: Icons.history,
                      text: 'Первый',
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: 'Второй',
                    )
                  ],
                  selectedIndex: navigationProvider.selectedIndex,
                  onTabChange: (index) {
                    Provider.of<NavigationProvider>(context, listen: false)
                        .updateIndex(index);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
