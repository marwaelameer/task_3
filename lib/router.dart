import 'package:go_router/go_router.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'products_page.dart';
import 'signup_page.dart';
import 'test.dart';

final router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    var path = state.matchedLocation;
    // Everything that starts with /home is protected: you must be logged in.
    if (path.startsWith("/home") && !Database.isLoggedIn) {
      return "/login";
    }
    return null;
  },
  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    // /signup is a TOP-LEVEL route, NOT under /home. Why? The redirect above
    // sends anyone who is not logged in away from every path starting with
    // "/home". A person who wants to sign up has no account yet, so they are
    // not logged in. If Signup lived at /home/signup, the redirect would throw
    // them back to /login and they could never reach the Signup page.
    GoRoute(path: "/signup", builder: (context, state) => const SignupPage()),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          builder: (context, state) => const ProductsPage(),
        ),
      ],
    ),
  ],
);
