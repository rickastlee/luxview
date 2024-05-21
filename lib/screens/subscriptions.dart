import 'package:flutter/material.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});
  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Row(
          children: <Widget>[
            Icon(
              Icons.play_circle_filled,
            ),
            Text('Subscriptions'),
          ],
        ),
      ),
      body: const Center(
        child: Text('SubscriptionsPage'),
      ),
    );
  }
}
