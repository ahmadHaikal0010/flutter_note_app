import 'package:flutter/material.dart';
import 'package:flutter_note_app/helper/db_helper.dart';
import 'package:flutter_note_app/model/note_model.dart';
import 'package:flutter_note_app/ui/add_note_view.dart';
import 'package:flutter_note_app/ui/detail_note_view.dart';

class ListDataNoteView extends StatefulWidget {
  const ListDataNoteView({super.key});

  @override
  State<ListDataNoteView> createState() => _ListDataNoteViewState();
}

class _ListDataNoteViewState extends State<ListDataNoteView> {
  List<NoteModel> _notes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDataBuku();
  }

  Future<void> _fetchDataBuku() async {
    setState(() {
      _isLoading = true;
    });

    final noteMaps = await DatabaseHelper.instance.queryAllBuku();
    setState(() {
      _notes = noteMaps.map((noteMaps) => NoteModel.fromMap(noteMaps)).toList();
      _isLoading = false;
    });
  }

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  _deleteFormDialog(BuildContext context, int noteId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Are you sure to delete this data?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () async {
                var result = await DatabaseHelper.instance.deleteBuku(noteId);
                if (result > 0) {
                  Navigator.pop(context);
                  _fetchDataBuku();
                  _showSuccessSnackBar('Note Id $noteId berhasil dihapus');
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchDataBuku,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailNoteView(note: _notes[index]),
                          ),
                        );
                        if (result == true) {
                          _fetchDataBuku(); // Auto refresh setelah edit
                        }
                      },
                      onLongPress: () {
                        _deleteFormDialog(context, _notes[index].id!);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _notes[index].judul,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteView()),
          );

          // Jika hasil bukan null, berarti ada catatan baru ditambahkan
          if (result != null) {
            _fetchDataBuku(); // Fetch ulang data
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
