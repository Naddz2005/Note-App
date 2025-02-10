class Note {
  Note({
    required this.title,
    required this.content,
    required this.id,
    required this.dateCreated,
    required this.lastModified,
    required this.tags,
  });

  final String? title;
  final String? content;
  final String id;
  final String dateCreated;
  final String lastModified;
  final String tags;
}