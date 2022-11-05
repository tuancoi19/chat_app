import 'package:chat_app/commons/app_commons.dart';
import 'package:chat_app/ui/home/chats/chats_screen.dart';
import 'package:chat_app/ui/home/contacts/contacts_cubit.dart';
import 'package:chat_app/ui/home/contacts/contacts_screen.dart';
import 'package:chat_app/ui/home/more/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final int pageIndex;
  const HomeScreen({super.key, required this.pageIndex});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  PageController controller = PageController();
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: PageView(controller: controller, children: [
          BlocProvider(
              create: (context) => ContactsCubit(),
              child: const ContactsScreen()),
          const ChatsScreen(),
          const MoreScreen()
        ]),
        bottomNavigationBar: SlidingClippedNavBar(
          backgroundColor: Theme.of(context).primaryColor,
          barItems: [
            BarItem(icon: Icons.people_outline, title: 'Contacts'),
            BarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
            BarItem(icon: Icons.more_horiz, title: 'More')
          ],
          activeColor: text_color,
          inactiveColor: text_color,
          onButtonPressed: (int index) {
            setState(() {
              selectedIndex = index;
            });
            controller.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
          },
          selectedIndex: selectedIndex,
        ),
      ),
    );
  }
}
