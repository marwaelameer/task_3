/*
PART 5.4 - Hidden bug
Login goes to Home with context.go("/home"), so the stack contains ONLY Home.
Pressing the old "go back" button (context.pop()) has nothing to pop, so
go_router throws "There is nothing to pop" and nothing happens on screen.
Fix: turn it into a "Logout" button that resets the login state and uses
go("/login") to replace the stack with the Login page.
*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'test.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print(" start Home");
    super.initState();
  }

  @override
  void dispose() {
    print(" finish Home");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("welcome to Home Page"),
            ElevatedButton(
              onPressed: () {
                Database.isLoggedIn = false;
                context.go("/login");
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
