import 'package:flutter/material.dart';
import 'package:flutter_note_app/helper/db_helper.dart';
import 'package:flutter_note_app/model/note_model.dart';

class DetailNoteView extends StatefulWidget {
  final NoteModel note;

  const DetailNoteView({super.key, required this.note});

  @override
  State<DetailNoteView> createState() => _DetailNoteViewState();
}

class _DetailNoteViewState extends State<DetailNoteView> {
  late TextEditingController _judulController;
  late TextEditingController _isiController;

  bool _isUpdated = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.note.judul);
    _isiController = TextEditingController(text: widget.note.isi);
  }

  Future<bool> _updateNoteIfNeeded() async {
    final newTitle = _judulController.text.trim();
    final newContent = _isiController.text.trim();

    // Hanya update jika konten berubah
    if ((newTitle != widget.note.judul || newContent != widget.note.isi) &&
        !_isUpdated) {
      final updatedNote = NoteModel(
        id: widget.note.id,
        judul: newTitle,
        isi: newContent,
      );

      await DatabaseHelper.instance.updateBuku(updatedNote);
      _isUpdated = true;
      Navigator.pop(context, true); // Kembalikan info untuk refresh
      return false; // Jangan pop dua kali
    }

    Navigator.pop(context); // Tidak berubah, keluar biasa
    return false;
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
      onWillPop: _updateNoteIfNeeded,
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
