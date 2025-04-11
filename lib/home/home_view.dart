import 'package:flutter/material.dart';
import '../check_net/check_net_page.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Network Checker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 100),
            const SizedBox(height: 20),
            Center(child: const CheckNetButton()),
          ],
        ),
      ),
    );
  }
}

class CheckNetButton extends StatelessWidget {
  const CheckNetButton({super.key});

  @override
  Widget build(BuildContext context) {
    final data = 'Check My Network';
    return FilledButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CheckNetPage()),
        );
      },
      style: FilledButton.styleFrom(backgroundColor: Colors.black),
      child: Text(
        data,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
