import 'package:flutter/material.dart';
import 'package:flutter_note_app/helper/db_helper.dart';
import 'package:flutter_note_app/model/note_model.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  bool _isSaved = false;

  Future<bool> _saveNoteIfNeeded() async {
    final title = _judulController.text.trim();
    final content = _isiController.text.trim();

    if (title.isNotEmpty || content.isNotEmpty) {
      if (!_isSaved) {
        var note = NoteModel(judul: title, isi: content);
        await DatabaseHelper.instance.insertBuku(note);
        _isSaved = true;
        Navigator.pop(context, true); // Berhasil simpan
        return false; // Kita sudah pop, jangan pop dua kali
      }
    } else {
      Navigator.pop(context); // Tidak ada isi, keluar biasa
      return false;
    }

    return true; // Boleh pop
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _saveNoteIfNeeded,
      child: Scaffold(
        appBar: AppBar(title: const Text('Note')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _isiController,
                  decoration: const InputDecoration(
                    hintText: 'Note something down...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
