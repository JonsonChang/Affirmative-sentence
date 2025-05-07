import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('肯定語句')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('管理肯定語句'),
              onPressed: () {
                // TODO: 導航至肯定語句管理頁
              },
            ),
            ElevatedButton(
              child: const Text('通知設定'),
              onPressed: () {
                // TODO: 導航至通知設定頁
              },
            ),
          ],
        ),
      ),
    );
  }
}
