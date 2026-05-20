import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'requests_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import 'post_task_screen.dart';
import 'sos_button.dart';
import 'ui/ui_helpers.dart';

class MainScreen extends StatefulWidget {
  final String userName;
  final int userKarma;

  const MainScreen({super.key, required this.userName, this.userKarma = 75});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(userName: widget.userName, userKarma: widget.userKarma),
      RequestsScreen(
        userName: widget.userName,
        onBack: () {
          setState(() {
            currentIndex = 0;
          });
        },
      ),
      Container(),
      MessagesScreen(
        onBack: () {
          setState(() {
            currentIndex = 0;
          });
        },
      ),
      ProfileScreen(
        userName: widget.userName,
        userKarma: widget.userKarma,
        onBack: () {
          setState(() {
            currentIndex = 0;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: SosButton(userName: widget.userName),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: GlassBottomNav(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, "Home", 0),
              _navItem(Icons.assignment, "Requests", 1),
              _postTaskItem(),
              _navItem(Icons.chat_bubble_outline, "Messages", 3),
              _navItem(Icons.person_outline, "Profile", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postTaskItem() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PostTaskScreen(userName: widget.userName),
          ),
        );
      },
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add_circle_outline, color: Colors.green, size: 26),
          SizedBox(height: 4),
          Text("Post", style: TextStyle(fontSize: 12, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.green : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
