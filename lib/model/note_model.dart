class NoteModel {
  final int? id;
  final String judul;
  final String isi;

  NoteModel({this.id, required this.judul, required this.isi});

  // insert data ke dalam map
  Map<String, dynamic> toMap() {
    return {'id': id, 'judul': judul, 'isi': isi};
  }

  // get data dari map
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(id: map['id'], judul: map['judul'], isi: map['isi']);
  }
}
