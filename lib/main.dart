import 'package:flutter/material.dart';
import 'package:flutter_note_app/ui/list_data_note_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListDataNoteView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
