class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.modifiedTime});
}

List<Note> sampleNotes = [
  Note(
      id: 0,
      title: 'Cumpleaños De Beto',
      content: 'Todo furro algo mal',
      modifiedTime: DateTime(2025, 2, 1, 34, 5)),
  Note(
      id: 1,
      title: 'Cumpleaños De Chris',
      content: 'No hay cp, cumple en decadencia',
      modifiedTime: DateTime(2025, 1, 1, 34, 5))
];
