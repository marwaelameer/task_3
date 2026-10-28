import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    print(" start Products");
    super.initState();
  }

  @override
  void dispose() {
    print(" finish Products");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text("welcome to Products Page"),
            ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("go back"),
            ),
          ],
        ),
      ),
    );
  }
}
