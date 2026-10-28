/*
=========================== ANSWERS ===========================

PART 1 - super.key
- What does super.key do? Where does the key go?
  `super.key` takes the optional `key` parameter of our widget constructor and
  passes it to the parent class constructor (StatefulWidget -> Widget).
  It goes in the widget CLASS constructor: `const LoginPage({super.key});`
  (not in the State class).
- Difference between Key? key (super.key) and GlobalKey<FormState> (_keyForm):
  The `Key? key` identifies the WIDGET inside the widget tree, so Flutter can
  tell widgets apart and keep/reuse their state when they rebuild or move.
  The `GlobalKey<FormState>` is attached to the Form so that WE can reach its
  FormState from our code and call validate() / save() / reset().
  One is for Flutter's tree bookkeeping, the other is for us to control the form.

PART 2 - why does const make Flutter faster?
  A const widget is created once at compile time and the same instance is
  reused. When the parent rebuilds, Flutter sees it's the identical object and
  skips rebuilding that whole subtree. Fewer rebuilds = faster.
  (const can't be used with runtime values like Text(username) or widgets
  that use a controller, because they're unknown at compile time.)

PART 3 - what does _ do in Dart? why private State?
  `_` makes a name private to its library (the file), so no other file can use
  it. State classes should be private because only the widget in the same file
  needs them (through createState). Nobody else should create or touch them,
  which keeps the API small and prevents misuse.

PART 5.3 - Experiments (go vs push)
Test 1: push("/signup") then pop()
  -> Went back to Login normally. Login was never disposed (no "finish Login"
     and no new "start Login"), because it stayed under Signup in the stack.
Test 2: go("/signup") then pop()
  -> Error "There is nothing to pop" in the console and the screen stays on
     Signup. go replaced the stack, so Signup is the only page.
Test 3: go("/signup") then go("/login")
  -> Worked, but Login was created again: "finish Login" when going to Signup,
     then "start Login" when coming back. The form was reset.
Test 4: push("/signup") then the AppBar/phone back arrow
  -> Same as pop(): returns to Login, Login state kept. The back arrow appears
     automatically in the AppBar because there's a page under Signup.
Is Login disposed when opening Signup?
  - With push: NO (it stays in the stack under Signup).
  - With go:   YES (the stack is replaced, "finish Login" is printed).

PART 5.4 - hidden bug: see home_page.dart

PART 5 - go vs push in my own words (using "stack")
  Navigation keeps a stack of pages. push puts a new page ON TOP of the stack,
  so the old page stays underneath and pop() can remove the top one to go back.
  go replaces the stack with the pages of the target route, so there is
  nothing underneath to pop back to, and the old page is disposed.
===============================================================
*/
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _keyForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _inputCheck() {
    if (_keyForm.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      if (username == Database.username && password == Database.password) {
        Database.isLoggedIn = true;
        context.go("/home");
      } else {
        _usernameController.clear();
        _passwordController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Wrong info")));
      }
    }
  }

  @override
  void initState() {
    print(" start Login");
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    print(" finish Login");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "please enter valid username ";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (((value?.length) ?? 0) < 6) {
                    return "please enter valid password";
                  }
                  return null;
                },
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _inputCheck,
                child: const Text("go to home "),
              ),
              TextButton(
                onPressed: () {
                  context.push("/signup");
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
